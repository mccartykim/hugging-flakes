{
  description = "TalkFlake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    packages.x86_64-linux = { 

      llama-2-7b-chat-q4-k-m-gguf = let
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
	    mkdir -p $out/share/models
	    cp llama-2-7b-chat.Q4_K_M.gguf $out
	  '';
      };
      
      llamaa = let
	modelUrl = "llama-2-7b-chat.Q4_K_M.gguf";
	pkgs = import nixpkgs {
	  system = "x86_64-linux";
	};
	in 
      pkgs.stdenv.mkDerivation {
      name = "llama-cpp-plus-model";
	  buildInputs = [ pkgs.llama-cpp pkgs.llama-2-7b-chat-q4-k-m-gguf ]; # Ensure llama-cpp is available


        installPhase = ''
          mkdir -p $out/bin
          echo "#!${pkgs.stdenv.shell}" > $out/bin/run-llama-cpp
          echo "${pkgs.llama-cpp}/bin/llama -m ${ pkgs.llama-2-7b-chat-q4-k-m-gguf }/llama-2-7b-chat.Q4_K_M.gguf" >> $out/bin/run-llama-cpp
          chmod +x $out/bin/run-llama-cpp
        '';
    };
  };
 };
 }
    
    
