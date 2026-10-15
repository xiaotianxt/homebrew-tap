class Mon < Formula
  desc "AI-native Monarch Money CLI for structured local finance workflows"
  homepage "https://github.com/xiaotianxt/mon"
  url "https://github.com/xiaotianxt/mon/releases/download/v0.4.1/mon-v0.4.1-darwin-arm64.tar.gz"
  sha256 "d8858d4afc66bf9ade41a46ac325060bafd9897f8b7d9bf82dc7402039649bbc"
  license "MIT"
  version "0.4.1"

  depends_on arch: :arm64

  head do
    url "https://github.com/xiaotianxt/mon.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", "--bin", "mon", "--root", prefix, "."
    else
      bin.install "mon"
    end
  end

  test do
    system "#{bin}/mon", "--help"
  end
end
