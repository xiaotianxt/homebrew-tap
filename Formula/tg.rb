class Tg < Formula
  desc "macOS Telegram 聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  url "https://github.com/xiaotianxt/tg/releases/download/v1.4.11/tg-v1.4.11-darwin-arm64.tar.gz"
  version "1.4.11"
  sha256 "dc3b583e2e7a89ce3afd8abec6042d8e78cbbe2a917700e3e0e043a4714113ae"
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
