class Tg < Formula
  desc "macOS Telegram 聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  url "https://github.com/xiaotianxt/tg/releases/download/v1.4.10/tg-v1.4.10-darwin-arm64.tar.gz"
  version "1.4.10"
  sha256 "2a66509e720b26b34d2f3d97a60350240e4b6df8c9a3dd97466cd35bea4a1ec8"
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
