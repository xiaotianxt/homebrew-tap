class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.2.0/tg-v2.2.0-darwin-arm64.tar.gz"
      sha256 "c1dd6eb8b131cceafba0b021104015c779a543f7509fa07036859fea1c6073ab"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.2.0/tg-v2.2.0-linux-arm64.tar.gz"
      sha256 "032e35c34e672d305f4141c3c000a7da366b9da4c738d7c07be44814d88c0202"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.2.0/tg-v2.2.0-linux-x86_64.tar.gz"
      sha256 "e28b764230e72381612dace17984f33e911eff80b9143cbb8cc81b2dd3d88a1a"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method lldb-login` uses Apple's lldb/debugserver while you log out and back in once.
      Install Apple Command Line Tools when that mode is needed:
        xcode-select --install
    EOS
  end

  def install
    bin.install "tg"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
