class Mon < Formula
  desc "AI-native Monarch Money CLI for structured local finance workflows"
  homepage "https://github.com/xiaotianxt/mon"
  url "https://github.com/xiaotianxt/mon/releases/download/v0.2.2/mon-v0.2.2-darwin-arm64.tar.gz"
  sha256 "5f297897392fc00b53365a96b5d58e5c258f821e2f20a9594d580a4ab695cbe6"
  license "MIT"
  version "0.2.2"

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
