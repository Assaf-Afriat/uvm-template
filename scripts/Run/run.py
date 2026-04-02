import os
import sys
import argparse
import subprocess
import time
import shutil
from pathlib import Path

# UVM-template — QuestaSim Run Script (same flow as uvm-alu-project)
# Usage: python run.py --test dut_base_test
# Run from: scripts/Run directory

# Questa's built-in UVM is 1.1d (mtiUvm in modelsim.ini). Default include search
# points to OVM, not UVM. We add +incdir+ to the 1.1d src so macros match the built-in.
UVM_MACROS_PATH = Path("C:/questasim64_2025.1_2/verilog_src/uvm-1.1d/src")

def run_command(command, step_name, cwd=None, timeout=None):
    print(f"\n{'='*60}")
    print(f"  {step_name}")
    print(f"{'='*60}")
    print(f"Command: {command}")
    if cwd:
        print(f"Working Dir: {cwd}")
    print()

    start_time = time.time()

    try:
        result = subprocess.run(
            command,
            shell=True,
            cwd=cwd,
            timeout=timeout
        )
        elapsed = time.time() - start_time

        if result.returncode != 0:
            print(f"\n[ERROR] Step '{step_name}' failed! (RC={result.returncode})")
            sys.exit(1)
        else:
            print(f"\n[OK] {step_name} completed in {elapsed:.2f}s")

    except subprocess.TimeoutExpired:
        print(f"\n[TIMEOUT] Step '{step_name}' exceeded {timeout}s timeout!")
        sys.exit(1)
    except KeyboardInterrupt:
        print(f"\n[INTERRUPTED] Step '{step_name}' was cancelled.")
        raise

def main():
    parser = argparse.ArgumentParser(
        description="UVM-template — QuestaSim Runner",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python run.py --test dut_base_test              # Run default test
  python run.py --test dut_base_test --gui        # Run with GUI
  python run.py --compile-only                    # Compile only
  python run.py --test dut_base_test --no-compile # Skip compilation
  python run.py --test dut_base_test --seed 12345 # Custom seed
  python run.py --clean                           # Clean work library
  python run.py --list                            # List available tests
        """
    )

    parser.add_argument('--test', type=str, default='dut_base_test',
                        help="UVM Test name (default: dut_base_test)")
    parser.add_argument('--seed', type=int, default=None,
                        help="Random seed (default: random)")
    parser.add_argument('--gui', action='store_true',
                        help="Run with QuestaSim GUI")
    parser.add_argument('--compile-only', action='store_true',
                        help="Only compile, don't run simulation")
    parser.add_argument('--no-compile', action='store_true',
                        help="Skip compilation (use existing work library)")
    parser.add_argument('--clean', action='store_true',
                        help="Clean sim/ and logs/ (coverage/ kept — source files live there)")
    parser.add_argument('--timeout', type=int, default=300,
                        help="Simulation timeout in seconds (default: 300)")
    parser.add_argument('--coverage', action='store_true',
                        help="Enable code coverage collection")
    parser.add_argument('--coverage-report', action='store_true',
                        help="Generate coverage report after simulation")
    parser.add_argument('--list', action='store_true',
                        help="List available tests")
    parser.add_argument('--verbosity', type=str, default='UVM_MEDIUM',
                        choices=['UVM_NONE', 'UVM_LOW', 'UVM_MEDIUM', 'UVM_HIGH', 'UVM_FULL', 'UVM_DEBUG'],
                        help="UVM verbosity level (default: UVM_MEDIUM)")

    args = parser.parse_args()

    # Paths
    run_dir = Path(__file__).parent.resolve()
    project_root = run_dir.parent.parent.resolve()
    sim_dir = project_root / "sim"
    logs_dir = project_root / "logs"
    coverage_dir = project_root / "coverage"

    print(f"\n{'#'*60}")
    print(f"  UVM-template — QuestaSim Runner")
    print(f"{'#'*60}")
    print(f"Project Root: {project_root}")
    print(f"Run Directory: {run_dir}")

    # List tests
    if args.list:
        print("\nAvailable Tests:")
        print("  - dut_base_test  : Base test (default)")
        print("\nUsage: python run.py --test <test_name>")
        return 0

    # Clean
    if args.clean:
        print("\n[CLEAN] Removing sim/ and logs/ (coverage/ kept)...")
        for d in (sim_dir, logs_dir):
            if d.exists():
                shutil.rmtree(d)
                print(f"  Removed: {d}")
        print("[CLEAN] Done.")
        if not args.compile_only:
            return 0

    # Create directories
    sim_dir.mkdir(exist_ok=True)
    logs_dir.mkdir(exist_ok=True)
    if args.coverage or args.coverage_report:
        coverage_dir.mkdir(exist_ok=True)

    os.chdir(project_root)

    # =========================================================================
    # COMPILE
    # =========================================================================
    if not args.no_compile:
        print("\n" + "="*60)
        print("  COMPILATION PHASE")
        print("="*60)

        run_command("vlib sim/work", "Create Work Library", cwd=project_root)
        run_command("vmap work sim/work", "Map Work Library", cwd=project_root)

        coverage_flags = "+cover=bcesft" if (args.coverage or args.coverage_report) else ""

        if not UVM_MACROS_PATH.is_dir():
            print(f"\n[ERROR] UVM macros dir not found: {UVM_MACROS_PATH}")
            print("Edit UVM_MACROS_PATH in run.py to point to your Questa's verilog_src/uvm-1.2/src")
            return 1
        print(f"[INFO] UVM macros: {UVM_MACROS_PATH}")

        # Compile interface
        run_command(
            "vlog -sv -work work +incdir+interface interface/dut_if.sv",
            "Compile Interface",
            cwd=project_root
        )

        # Compile DUT
        run_command(
            f"vlog -sv -work work {coverage_flags} +incdir+dut dut/dut.sv",
            "Compile DUT",
            cwd=project_root
        )

        # Compile SVA Assertions
        run_command(
            "vlog -sv -work work +incdir+sva sva/dut_assertions.sv",
            "Compile SVA",
            cwd=project_root
        )

        # Compile testbench top (includes dut_pkg.sv which includes all UVM components)
        run_command(
            f"vlog -sv -work work "
            f"+incdir+{UVM_MACROS_PATH} "
            "+incdir+. +incdir+pkg +incdir+agent +incdir+env +incdir+scoreboard "
            "+incdir+coverage +incdir+sequences +incdir+test +incdir+transaction "
            "+incdir+config +incdir+callbacks +incdir+interface "
            "tb_top.sv",
            "Compile Testbench",
            cwd=project_root
        )

        print("\n[OK] Compilation successful!")

    if args.compile_only:
        print("\n[DONE] Compile-only mode. Exiting.")
        return 0

    # =========================================================================
    # ELABORATE
    # =========================================================================
    print("\n" + "="*60)
    print("  ELABORATION PHASE")
    print("="*60)

    coverage_opt = "+cover=bcesft" if (args.coverage or args.coverage_report) else ""
    run_command(
        f"vopt +acc=npr {coverage_opt} -o tb_top_opt work.tb_top",
        "Elaborate Design",
        cwd=project_root
    )

    # =========================================================================
    # SIMULATE
    # =========================================================================
    print("\n" + "="*60)
    print("  SIMULATION PHASE")
    print("="*60)
    print(f"Test: {args.test}")
    print(f"Verbosity: {args.verbosity}")
    if args.seed:
        print(f"Seed: {args.seed}")

    log_file = logs_dir / f"{args.test}.log"
    wlf_file = logs_dir / f"{args.test}.wlf"
    ucdb_file = coverage_dir / f"{args.test}.ucdb"

    seed_arg = f"-sv_seed {args.seed}" if args.seed else "-sv_seed random"

    coverage_args = ""
    if args.coverage or args.coverage_report:
        coverage_args = f"-coverage -coverstore {coverage_dir}"

    if args.gui:
        sim_cmd = (
            f"vsim -gui {coverage_args} {seed_arg} "
            f"+UVM_TESTNAME={args.test} "
            f"+UVM_VERBOSITY={args.verbosity} "
            f"-wlf {wlf_file} "
            f"-l {log_file} "
            f"tb_top_opt"
        )
    else:
        do_commands = "run -all; quit -f"
        if args.coverage or args.coverage_report:
            do_commands = f"coverage save -onexit {ucdb_file}; run -all; quit -f"

        sim_cmd = (
            f"vsim -c {coverage_args} {seed_arg} "
            f"+UVM_TESTNAME={args.test} "
            f"+UVM_VERBOSITY={args.verbosity} "
            f"-wlf {wlf_file} "
            f"-l {log_file} "
            f"-do \"{do_commands}\" "
            f"tb_top_opt"
        )

    run_command(sim_cmd, f"Simulate {args.test}", cwd=project_root, timeout=args.timeout if not args.gui else None)

    # =========================================================================
    # COVERAGE REPORT
    # =========================================================================
    if args.coverage_report:
        print("\n" + "="*60)
        print("  COVERAGE REPORT")
        print("="*60)

        report_txt = coverage_dir / f"{args.test}_coverage.txt"
        report_html = coverage_dir / "html"

        run_command(
            f"vcover report -details -output {report_txt} {ucdb_file}",
            "Generate Text Report",
            cwd=project_root
        )

        run_command(
            f"vcover report -html -htmldir {report_html} {ucdb_file}",
            "Generate HTML Report",
            cwd=project_root
        )

        print(f"\nCoverage Reports:")
        print(f"  Text: {report_txt}")
        print(f"  HTML: {report_html}/index.html")

    # =========================================================================
    # SUMMARY
    # =========================================================================
    print("\n" + "#"*60)
    print("  SIMULATION COMPLETE")
    print("#"*60)
    print(f"Test: {args.test}")
    print(f"Log: {log_file}")
    print(f"Waveform: {wlf_file}")
    if args.coverage or args.coverage_report:
        print(f"Coverage: {ucdb_file}")
    print()

    return 0

if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\n\n[INTERRUPTED] Simulation cancelled by user.")
        sys.exit(130)
    except Exception as e:
        print(f"\n[FATAL] {e}")
        sys.exit(1)
