{
 stdenv,
 lib,
 fetchgit,
 writeShellScriptBin,
 pkgs,
 ...
}: let
      model = fetchgit {
        url = "https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF.git";
        rev = "191239b3e26b2882fb562ffccdd1cf0f65402adb";
        hash = "08a5566d61d7cb6b420c3e4387a39e0078e1f2fe5f055f3a03887385304d4bfa";
        fetchLFS = "true";
      };
  in 
    pkgs.writeShellScriptBin "llama2" ''
      ${pkgs.llama-cpp}/bin/llama-cpp-main ${model}/llama-2-7b-chat.Q4_K_M.gguf
  ''
