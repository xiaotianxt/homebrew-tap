class Mon < Formula
  desc "AI-native Monarch Money CLI for structured local finance workflows"
  homepage "https://github.com/xiaotianxt/mon"
  url "https://github.com/xiaotianxt/mon/releases/download/v0.5.0/mon-v0.5.0-darwin-arm64.tar.gz"
  sha256 "dc49cccb6108e02bd2c9f9b01b841f534c09ec0b0cd9f0167e0a23ca35415eb7"
  license "MIT"
  version "0.5.0"

  depends_on arch: :arm64

  head do
    url "https://github.com/xiaotianxt/mon.git", branch: "main"
    depends_on "go" => :build
  end

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w"), "."
    else
      bin.install "mon"
    end
  end

  test do
    system "#{bin}/mon", "--help"
  end
end
