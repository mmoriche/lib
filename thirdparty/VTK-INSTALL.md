# At flo

```
# see config/add/flo/bashrc for VTK_ROOT and VTK_DATA_ROOT
# export VTK_ROOT=/opt/VTK/VTK
# export VTK_ROOT=/opt/VTK/VTKData
cd 
mkdir -p tmp/vtkbuild/
cd tmp/vtkbuild
tar -xzvf ${TANK_PATH}/WORK/lib/thirdparty/VTK-9.0.0.tar.gz  
```


About this file
===============
This file describes how to build and install VTK (with the Python
wrapper) locally on RHEL 6.

Prerequisites: CMake, Tcl, Python, NumPy

Compilation
===========
Create a local installation directory with the command

 mkdir $HOME/VTK

Download and unpack the files vtk-5.10.0.tar.gz and
vtkdata-5.10.0.tar.gz into this directory, so that you end up with the
directory structure

 $HOME/VTK/VTK
 $HOME/VTK/VTKData

Add the following lines to your .bashrc file

 export VTK_ROOT=$HOME/VTK/VTK
 export VTK_DATA_ROOT=$HOME/VTK/VTKData

and run the command

 source $HOME/.bashrc

Build VTK with CMake by typing
 
 cd $VTK_ROOT
 mkdir build
 cd build
 cmake ../ -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Release -DVTK_WRAP_PYTHON=ON
 make -j5

Check that the installation works by typing

 make test

The following tests will probably fail

 555 - TestScenePicker (Failed)
 618 - TestProjectedTetrahedra (SEGFAULT)
 871 - Geovis-TestLabeledGeoView2D (Failed)
 912 - Charts-TestScatterPlotMatrix (Failed)
 913 - Charts-TestScatterPlotMatrixVisible (Failed)

but overall the installation should work.

Python wrapper
==============
Add the following lines to your .bashrc file:

 export PYTHONPATH=$VTK_ROOT/build/Wrapping/Python/:$VTK_ROOT/build/bin
 export LD_LIBRARY_PATH=$VTK_ROOT/build/bin:$LD_LIBRARY_PATH

and run the command

 source $HOME/.bashrc

Check that the wrapper works by typing

 python
 import vtk

Python should be able to import the vtk module without errors.

Clean-up
========
Remove vtk-5.10.0.tar.gz and vtkdata-5.10.0.tar.gz from the VTK_ROOT
directory.

