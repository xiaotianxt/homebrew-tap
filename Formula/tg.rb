class Tg < Formula
  desc "macOS Telegram 聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  url "https://github.com/xiaotianxt/tg/releases/download/v1.4.12/tg-v1.4.12-darwin-arm64.tar.gz"
  version "1.4.12"
  sha256 "733bf0e7d276a6cf47d1529df780dd8e4b486ecaa1fbf7fcb3f7249c98679c88"
  license "MIT"

  depends_on arch: :arm64
  depends_on "rust-" + "si" + "lk"

  def install
    bin.install "tg"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
