# Oberon-enhanced-Oberon07-compiler
Enhanced Oberon-07 compiler for the Project Oberon 2013 operating system, including the following features:

* Dynamic heap allocation procedure for fixed-length and open arrays
* Numeric case statement
* Exporting and importing of string constants
* No access to intermediate objects within nested scopes
* Forward references and forward declarations of procedures (experimental feature)
* Module contexts (experimental feature)

Note: The term "Project Oberon 2013" refers to a re-implementation of the original "Project Oberon" on an FPGA development board around 2013, as published at www.projectoberon.com.

------------------------------------------------------
**Documentation:** [**Enhanced-Oberon07-compiler.pdf**](Documentation/Enhanced-Oberon07-compiler.pdf)

**Note:** This compiler implements only a **subset** of the compiler provided in Extended Oberon. In particular, Oberon-2 style type-bound procedures are **not** implemented (as it would require changing the format of the symbol file).

------------------------------------------------------
# Instructions for using the enhanced Oberon-07 compiler under Project Oberon 2013

**PREREQUISITES:** A current version of Project Oberon 2013 (see http://www.projectoberon.com). If you use Extended Oberon (see http://github.com/andreaspirklbauer/Oberon-extended), the functionality is already implemented.

**NOTE:** If you run Oberon in an emulator (e.g., https://github.com/pdewacht/oberon-risc-emu), you can simply backup your existing S3RISCinstall directory, download the compressed archive [**S3RISCinstall.tar.gz**](Documentation/S3RISCinstall.tar.gz) from this repository to your emulator directory, run the command *tar xvzf S3RISCinstall.tar.gz* in that directory and then restart the emulator, instead of going through the instructions outlined below.

------------------------------------------------------

**STEP 1**: Build a slightly modified Oberon compiler on your Project Oberon 2013 system

Edit the file *ORG.Mod* on your original Project Oberon 2013 system and set the following constants to the indicated new values:

     CONST ...
       maxCode = 8400; maxStrx = 3200; ...

Then recompile the modified file of your Project Oberon 2013 compiler (and unload the old one):

     ORP.Compile ORG.Mod/s ~
     System.Free ORTool ORP ORG ~

This step is (unfortunately) necessary since the original Oberon-07 compiler has a tick too restrictive constants. To compile the enhanced Oberon-07 compiler, one needs slightly more space (in the compiler) for both *code* and *string constants*.

------------------------------------------------------

**STEP 2**: Download and import the files to build the enhanced Oberon-07 to your system

Download all files from the [**Sources**](Sources/) directory of this repository. Convert the *source* files to Oberon format (Oberon uses CR as line endings) using the command [**dos2oberon**](dos2oberon), also available in this repository (example shown for Linux or MacOS):

     for x in *.Mod ; do ./dos2oberon $x $x ; done

Import the files to your Oberon system. If you use an emulator, click on the *PCLink1.Run* link in the *System.Tool* viewer, copy the files to the emulator directory, and execute the following command on the command shell of your host system:

     cd oberon-risc-emu
     for x in *.Mod ; do ./pcreceive.sh $x ; sleep 0.5 ; done

------------------------------------------------------

**STEP 3:** Build the enhanced ("new") Oberon-07 compiler and boot linker/loader on the "old" system

     ORP.Compile ORS.Mod/s ORB.Mod/s ~
     ORP.Compile ORG.Mod/s ORP.Mod/s ~
     ORP.Compile ORL.Mod/s ORTool.Mod/s ~
     System.Free ORTool ORP ORG ORB ORS ORL ~

------------------------------------------------------

**STEP 4:** Use the new toolchain on your original system to rebuild the entire system and compiler

Compile the *inner core* and load it onto the boot area of the local disk:

     ORP.Compile Kernel.Mod FileDir.Mod Files.Mod Modules.Mod ~    # modules for the "regular" boot file
     ORL.Link Modules ~                                            # generate a pre-linked binary file of the "regular" boot file (Modules.bin)
     ORL.Load Modules.bin ~                                        # load the "regular" boot file onto the boot area of the local disk

Compile the remaining modules of the Oberon system:

     ORP.Compile Input.Mod Display.Mod/s Viewers.Mod/s ~
     ORP.Compile Fonts.Mod/s Texts.Mod/s Oberon.Mod/s ~
     ORP.Compile MenuViewers.Mod/s TextFrames.Mod/s ~
     ORP.Compile System.Mod/s Edit.Mod/s Tools.Mod/s ~

Re-compile the enhanced Oberon-07 compiler itself before (!) restarting the system:

     ORP.Compile ORS.Mod/s ORB.Mod/s ~
     ORP.Compile ORG.Mod/s ORP.Mod/s ~
     ORP.Compile ORL.Mod/s ORX.Mod/s ORTool.Mod/s ~

The last step is necessary because the modified version of your Oberon system uses a different Oberon object file format. If you don't re-compile the compiler before restarting the Oberon system, you won't be able to start it afterwards!

------------------------------------------------------

**STEP 5:** Restart the Oberon system

You are now running a modified Oberon system with an enhanced Oberon-07 compiler. Re-compile any other modules that you may have on your system.


