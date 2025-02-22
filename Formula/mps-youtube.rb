class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.8.tar.gz"
  sha256 "d5f2c4bc1f57f0566242c4a0a721a5ceaa6d6d407f9d6dd29009a714a0abec74"
  revision 8

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "97d97b734d3371938920e2d1b3a5e180a58c29441b376a2bfa9d2a3c52aef220" => :mojave
    sha256 "7a358b9c265b5db8ad8367bdeb42e6b4b3f0164f66db91a80119b83c3a459016" => :high_sierra
    sha256 "ecda06ebd06fda0260cf4e97490ff41c53ed070bd97c5ad61f4d52775813f0c2" => :sierra
  end

  depends_on "mpv"
  depends_on "python"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/41/cb/ec840c79942fb0788982963b61a361ecd10e4e58ad3dcaef4f0e809ce2fe/pafy-0.5.4.tar.gz"
    sha256 "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/25/fa/92097e9d95470ac12211b6f63744d159f473952ad01e9dd869edc62fb42d/youtube_dl-2019.7.30.tar.gz"
    sha256 "41ee1e4247ed3810d9730c54b25ebe4ca19c1ca7373e3de05a3dc8e8884ca475"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    %w[youtube_dl pafy].each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/Drop4Drop x Ed Sheeran,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
