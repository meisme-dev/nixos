driverPackage:

let
  patches = {
    "545.29.06" = "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
  };
in driverPackage.overrideAttrs ({ version, preFixup ? "", ... }: {
  preFixup = preFixup + ''
    sed -i '${
      builtins.getAttr version patches
    }' $out/lib/libnvidia-fbc.so.${version}
  '';
})
