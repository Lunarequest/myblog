{ stdenv, hugo, fetchgit }:

{
  pname="my blog";
  version = "1.0.0";
  src = fetchgit {
    "url": "https://codeberg.org/lunarequest/myblog.git",
    "rev": "6d081dc1a29deadd44f6c9f054f6cb92acdfa7a1",
    "sha256": "0b3hkah6p5ipj8kx52g0q9prsgg77jqs0dm03zrxy1w33fbmg81k",
    "fetchSubmodules": true,
  };

  buildInputs = [ hugo ];
  
  buildphase = ''
    hugo --gc --minify -b https://nullrequest.com/
  '';

  installPhase = ''
    mkdir -p $out/usr/share/
    cp -r public $out/usr/share/blog
  '';

}