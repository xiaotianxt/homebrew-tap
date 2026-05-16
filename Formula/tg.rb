class Tg < Formula
  desc "macOS Telegram 聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  url "https://github.com/xiaotianxt/tg/releases/download/v1.4.9/tg-v1.4.9-darwin-arm64.tar.gz"
  version "1.4.9"
  sha256 "6e1ce531f908757650946c5299ca407a950682265fb6ad6dfe59615f7a42a495"
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
