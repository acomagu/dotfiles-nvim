{
  description = "acomagu dotfiles for Neovim";

  outputs = { self, ... }: {
    # home-manager から import できるモジュールを公開
    homeManagerModules.default = { ... }: {
      home.file.".config/nvim/init.lua".source = self + "/init.lua";
      home.file.".config/nvim/colors/minicomment.vim".source = self + "/colors/minicomment.vim";
    };
  };
}
