{ stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, wrapGAppsHook
, gobject-introspection
, glib
, json-glib
, tracker
, atk
, cairo
, gtk3
, libgee
, gtk-layer-shell
}:

stdenv.mkDerivation rec {
  pname = "ilia";
  version = "r3_0-ubuntu-jammy";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = pname;
    rev = version;
    sha256 = "sha256-4MKVwaepLOaxHFSwiks5InDbKt+B/Q2c97mM5yHz4eU=";
  };

  preConfigure = ''
    patchShebangs "meson_scripts"
  '';

  nativeBuildInputs = [ meson ninja vala pkg-config wrapGAppsHook ];

  buildInputs = [ gobject-introspection glib json-glib tracker atk cairo gtk3 libgee gtk-layer-shell ];
}
