{
  description = "TalkFlake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    packages.x86_64-linux = 
      let model = 
	let
	  pkgs = import nixpkgs {
	    system = "x86_64-linux";
	  };
	  in pkgs.stdenv.mkDerivation {
	    name = "llama2 7b chat q4 k m gguf";
	    src = pkgs.fetchgit {
	      url = "https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF.git";
	      rev = "191239b3e26b2882fb562ffccdd1cf0f65402adb";
	      hash = "sha256-WeRLiFFEDX4lNqHVAh9KnplmKGlpWXSDXlKfu2AatqE=";
	      fetchLFS = true;
	      sparseCheckout = [ "llama-2-7b-chat.Q4_K_M.gguf" ];
	    };

	    installPhase = ''
	      cp llama-2-7b-chat.Q4_K_M.gguf $out
	    '';
	};
	in rec {
      llama-2-7b-chat-q4-k-m-gguf = model;
      
      llamaa = let
	modelUrl = "llama-2-7b-chat.Q4_K_M.gguf";
	pkgs = import nixpkgs {
	  system = "x86_64-linux";
	  nixpkgs.x86_64-linux.llama-2-7b-chat-q4-k-m-gguf = model;
	};
	in 
      pkgs.writeShellApplication {
      name = "llama-cpp-plus-model";
	  runtimeInputs = [ 
	  pkgs.llama-cpp 
	  model
	  ]; # Ensure llama-cpp is available


        text = "${pkgs.llama-cpp}/bin/llama -m ${model}/llama-2-7b-chat.Q4_K_M.gguf";
    };
  };
 };
 }
    
    
