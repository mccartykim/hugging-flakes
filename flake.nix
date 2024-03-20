{
  description = "TalkFlake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    packages.x86_64-linux = 
      let 
	modelUrl = "llama-2-7b-chat.Q4_K_M.gguf";
	pkgs = import nixpkgs {
	  system = "x86_64-linux";
	};
        model = pkgs.stdenv.mkDerivation {
	  name = "llama2 7b chat q4 k m gguf";
	  buildPackages = [ pkgs.python311Packages.huggingface-hub ];
	  __no_chroot = true;
	  src = let 
	    owner = "TheBloke";
	    repo = "Llama-2-7B-Chat-GGUF";
	    file = "llama-2-7b-chat.Q4_K_M.gguf";
	  in
	    pkgs.runCommand "get-model" { 
	      outputHashAlgo = "sha256";
	      outputHashMode = "recursive";
	      outputHash = ""; 
	    } ''
	      ${pkgs.python311Packages.huggingface-hub}/bin/huggingface-cli download --local-dir . "${owner}/${repo}" "${file}"
	      mkdir -p $out/share/gguf
	      cp ./${file} $out/share/gguf
	    '';

	  # fetchgit {
	  #  url = "https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF.git";
	  #  rev = "191239b3e26b2882fb562ffccdd1cf0f65402adb";
	  #  hash = "sha256-WeRLiFFEDX4lNqHVAh9KnplmKGlpWXSDXlKfu2AatqE=";
	  #  fetchLFS = true;
	  #  sparseCheckout = [ "llama-2-7b-chat.Q4_K_M.gguf" ];
	  # };
	};
	in rec {
      llama-2-7b-chat-q4-k-m-gguf = model;
      
      llamaa = pkgs.writeShellApplication {
	name = "llama-cpp-plus-model";
	  runtimeInputs = [ 
	  pkgs.llama-cpp 
	  model
	  ]; # Ensure llama-cpp is available


        text = "${pkgs.llama-cpp}/bin/llama -m ${ model }/share/gguf/llama-2-7b-chat.Q4_K_M.gguf";
    };
  };
 };
 }
    
    
