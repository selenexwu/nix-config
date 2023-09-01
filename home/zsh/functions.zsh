nix-build-package () {
	nix build --impure --expr "(import <nixpkgs> {}).callPackage (import ./$1) {}"
}
