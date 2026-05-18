class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.17"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.17/tg-v1.4.17-darwin-arm64.tar.gz"
      sha256 "3f33f9a353c2a608dd868fe0f5f3f3cfa388c21b956dee8e8f0f5bc523c88660"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.17/tg-v1.4.17-linux-arm64.tar.gz"
      sha256 "4ab9437b0d97dff2ba6d80a9010bed1ec7e196c90c4888f98f6e76fa0aa0d8b7"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.17/tg-v1.4.17-linux-x86_64.tar.gz"
      sha256 "b18e664bf7dbd342024759d52e35353c374a6b1a63f9c0cdb006fee5181a0176"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def install
    bin.install "tg"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
