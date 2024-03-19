{
  description = "TalkFlake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
	  forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
	in
  {
    packages = forAllSystems (system: 
    let 
      pkgs = nixpkgs.legacyPackages.${system};
      model = pkgs.fetchurl {
        url = "https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/raw/main/llama-2-7b-chat.Q4_K_M.gguf?download=true";
	sha256="08a5566d61d7cb6b420c3e4387a39e0078e1f2fe5f055f3a03887385304d4bfa";
      };
    in {
      llama2 = pkgs.writeShellScriptBin "llama2-chat" '' 
        ${pkgs.llama-cpp}/bin/llama-cpp-main${model}
      '';
    }
    );
 };
}
    
    
