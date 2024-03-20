{
  description = "TalkFlake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let 
	modelUrl = "llama-2-7b-chat.Q4_K_M.gguf";
	pkgs = import nixpkgs {
	  system = system;
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
	      outputHashMode = "flat";
	      outputHash = "";
	    } ''
	      # Homeless huggingface bug workaround
	      export HOME=$(pwd)
	      ${pkgs.python311Packages.huggingface-hub}/bin/huggingface-cli download --local-dir . "${owner}/${repo}" "${file}"
	      cp ./${file} $out
	    '';
	llamaa = pkgs.writeShellApplication {
	  name = "llama-cpp-plus-model";
	    runtimeInputs = [ 
	      pkgs.llama-cpp 
	      model
	    ];

	  text = "${pkgs.llama-cpp}/bin/llama -m ${ model }";
	};
      in 
	{ packages = rec {
	  llama-2-7b-chat-q4-k-m-gguf = model;
	  default = llamaa;
	  
	};
      }
   );
 }
