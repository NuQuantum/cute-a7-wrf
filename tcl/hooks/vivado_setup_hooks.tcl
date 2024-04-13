
# Setup hook scripts, to be called at various stages during the build process
# See Xilinx UG 894 ("Using Tcl Scripting") for documentation.

# This flow is managed by FuseSoC and the Tcl hook scripts are copied into the FuseSoC
# build directory.  This is the same directory that Vivado is launched from meaning we 
# will find the scripts in the current working directory.
set cwd [pwd]

# Pre synth design hook
set_property STEPS.SYNTH_DESIGN.TCL.PRE "${cwd}/hook_synth_design_pre.tcl" [get_runs synth_1]

# Post synth design hook
set_property STEPS.SYNTH_DESIGN.TCL.POST "${cwd}/hook_synth_design_post.tcl" [get_runs synth_1]

# Post route design hook
set_property STEPS.ROUTE_DESIGN.TCL.POST "${cwd}/hook_route_design_post.tcl" [get_runs impl_1]

# Pre bitstream hook
set_property STEPS.WRITE_BITSTREAM.TCL.PRE "${cwd}/hook_write_bitstream_pre.tcl" [get_runs impl_1]

# Post bitstream hook
set_property STEPS.WRITE_BITSTREAM.TCL.POST "${cwd}/hook_write_bitstream_post.tcl" [get_runs impl_1]