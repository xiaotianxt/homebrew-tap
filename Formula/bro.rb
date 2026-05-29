class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "0.2.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.2/bro-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "b5116cf8df8e2b92fc838a66e867c12fba3ac6585df038efae1554cca92dce5c"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.2/bro-v0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "84f801d62e231e17c6c855e34e96a780300114e0148a6f254edf81be6afe209c"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.2/bro-v0.2.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a18a03c32ac55c29f824935ed5aedc35cc69f8dc349f3359a128117f8ecfc360"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v0.2.2/bro-v0.2.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c399bb43b5a79857f67a3e4e92ca52c9de367654c529e9231fbc988c900e0c54"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v0.2.2/bro-extension-v0.2.2.zip"
    sha256 "8ef379f5b59d8df1f02a43b1346e3957b7a71428141f21d59019be0be4ac3dc6"
  end

  def install
    if build.head?
      system "cargo", "install", "--locked", "--bin", "bro", "--root", prefix, "."
    else
      bin.install "bro"
    end

    resource("extension").stage do
      (share/"bro/extension").install Dir["*"]
    end
  end

  service do
    run [opt_bin/"bro", "serve"]
    keep_alive true
    log_path var/"log/bro.log"
    error_log_path var/"log/bro.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bro --version")
    assert_predicate share/"bro/extension/manifest.json", :exist?
  end
end
