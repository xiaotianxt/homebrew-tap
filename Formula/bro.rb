class Bro < Formula
  desc "Local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "2.3.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.3.0/bro-v2.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "20e09891c7edf903d0c71816477ccad53914678167ae5c18ac5da628e504d599"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.3.0/bro-v2.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "894c18520c0a249ce0cc3b1500d336336c7dfa46162bbe99f400130bc23b5a14"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.3.0/bro-v2.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5578769c22912c6e42f66aa97fe1ce7bdf7052d09b1d85330e86c69dce06df52"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v2.3.0/bro-v2.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "77637cd83b75660bacd3a13a97e98235e350e78b348556a9e249d1298ae37325"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "go" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v2.3.0/bro-extension-v2.3.0.zip"
    sha256 "f1ee2c6978b46095bec6929853556e2f4d4e61fd61b1c7080990fe50186b3bd8"
  end

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"bro"), "./cmd/bro"
    else
      bin.install "bro"
    end

    resource("extension").stage do
      (share/"bro/extension").install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      Finish setting up bro (background service, browser extension, MCP clients):
        bro setup
      Run it again after upgrading; it restarts the service on the new version.
    EOS
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
