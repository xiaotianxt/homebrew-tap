class Mon < Formula
  desc "AI-native Monarch Money CLI for structured local finance workflows"
  homepage "https://github.com/xiaotianxt/mon"
  url "https://github.com/xiaotianxt/mon/releases/download/v0.3.0/mon-v0.3.0-darwin-arm64.tar.gz"
  sha256 "74b485930ef3c1481ad8ec3c8516aec1bd0e35f248f188968348f5532c6c5005"
  license "MIT"
  version "0.3.0"

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
