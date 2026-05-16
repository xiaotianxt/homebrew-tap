class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.15"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.15/tg-v1.4.15-darwin-arm64.tar.gz"
      sha256 "072a658524dc010fb779cdd19d3de2a2e1a8472105982e5df12facbd76799e2f"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.15/tg-v1.4.15-linux-arm64.tar.gz"
      sha256 "8f4ab3e65ccedf731c948f7a87c6e727bf272c5d222ce7a827f6cf4d81f2352e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.15/tg-v1.4.15-linux-x86_64.tar.gz"
      sha256 "0e397e08b649c9e667cad5ab2d9f4051896eabdcff37a4ad69fdbb6dea977495"
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
