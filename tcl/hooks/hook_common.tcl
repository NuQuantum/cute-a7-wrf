namespace eval hooks {
  # Define the top level module name
  set toplevel [get_property -verbose top [current_fileset]]
  
  # The Project flow runs from <toplevel>.runs/synth_1 which is 2 levels of hierarchy
  set build_root [file normalize "../../"]

  # Define all output directories
  set log_dir $build_root/log
  set report_dir $build_root/report
  set netlist_dir $build_root/netlist
  set platform_dir $build_root/platform
  set output_dirs [list $log_dir $report_dir $netlist_dir $platform_dir]

  proc create_output_dirs {} {
    variable output_dirs
    foreach dir $output_dirs  {
      file mkdir $dir
    }
  }

  proc write_verilog_netlist {phase} {
    variable toplevel
    variable netlist_dir
    write_verilog -force -mode funcsim -include_xilinx_libs ${netlist_dir}/${toplevel}_${phase}.v
  }

  proc write_reports {phase} {
    variable toplevel
    variable report_dir
    report_utilization -file ${report_dir}/${toplevel}_${phase}_util.rpt

    if { $phase != "synth" } {
      report_timing_summary -file ${report_dir}/${toplevel}_${phase}_timing_summary.rpt -report_unconstrained -warn_on_violation
      report_timing -file ${report_dir}/${toplevel}_${phase}_timing.rpt -sort_by group -max_paths 20
    }
  }

  proc write_platform {} {
    variable toplevel
    variable platform_dir
    write_hw_platform -fixed -include_bit -force -file ${platform_dir}/${toplevel}.xsa
  }

}