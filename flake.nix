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
        model = 
	  let 
	    owner = "TheBloke";
	    repo = "Llama-2-7B-Chat-GGUF";
	    file = "llama-2-7b-chat.Q4_K_M.gguf";
	  in
	    pkgs.runCommand "get-model" { 
	      name = "llama2 7b chat q4 k m gguf";
	      buildPackages = [ pkgs.python311Packages.huggingface-hub ];
	      outputHashAlgo = "sha256";
	      outputHashMode = "recursive";
	      outputHash = ""; 
	    } ''
	      # Homeless huggingface bug workaround
	      export HOME=$(pwd)
	      ${pkgs.python311Packages.huggingface-hub}/bin/huggingface-cli download --local-dir . "${owner}/${repo}" "${file}"
	      mkdir -p $out/share/gguf
	      cp ./${file} $out/share/gguf
	    '';
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
    
    
