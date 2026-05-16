class Tg < Formula
  desc "macOS Telegram 聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.13"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.13/tg-v1.4.13-darwin-arm64.tar.gz"
      sha256 "32e76610472e1626da645f0618f1de09bace62878834187de3e95e2ccc63ce97"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.13/tg-v1.4.13-linux-arm64.tar.gz"
      sha256 "b94d7b31d641e07d28a177f32559d20ecdac812cf7f4ce6dc3db2e94ef1f507e"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.13/tg-v1.4.13-linux-x86_64.tar.gz"
      sha256 "05f85c95f2bc8c0dc1368fd9876c073b0bf5988baa53f3eeb29aff6509f6557e"
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
