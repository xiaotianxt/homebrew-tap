cask "alt-tab" do
  version :latest
  sha256 :no_check

  url "https://github.com/xiaotianxt/alt-tab-macos/releases/latest/download/AltTab-local-pro.zip",
      verified: "github.com/xiaotianxt/alt-tab-macos/"
  name "AltTab Local Pro"
  desc "Automatically rebased local testing build of AltTab"
  homepage "https://github.com/xiaotianxt/alt-tab-macos"

  auto_updates true
  depends_on :macos

  app "AltTab.app"

  uninstall quit: "com.lwouis.alt-tab-macos"

  caveats <<~EOS
    This local testing build is ad-hoc signed and not notarized by Apple.
  EOS
end
