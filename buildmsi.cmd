pushd %~dp0
msbuild /t:Clean SketchUpPluginsStandalone.wixproj
msbuild SketchUpPluginsStandalone.wixproj
popd