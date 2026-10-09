cask "taigikeyboard" do
  version "3.7.0"
  sha256 "08f0adbd913fd5e50098b2359245f1ea0305bd9b000bc951abe03600e5ec3d02"

  # Served from the project's Cloudflare R2 mirror (GitHub release assets are
  # slow on some Taiwanese ISPs); the same bytes as the GitHub release asset.
  url "https://dl.taigikeyboard.tw/desktop/TaigiKeyboard-#{version}.pkg"
  name "TaigiKeyboard"
  desc "Taiwanese input method (POJ / TL / TPS, Hanji)"
  homepage "https://github.com/taigikeyboard/taigikeyboard"

  # Desktop releases share one tag across macOS / Windows / Linux, and some are
  # platform-only patches. Only a published release carrying a macOS .pkg counts.
  livecheck do
    url "https://github.com/taigikeyboard/taigikeyboard"
    regex(/^TaigiKeyboard[._-]v?(\d+(?:\.\d+)+)\.pkg$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  auto_updates true
  depends_on macos: :sonoma

  pkg "TaigiKeyboard-#{version}.pkg"

  uninstall pkgutil: "com.siansiansu.inputmethod.TaigiKeyboard",
            delete:  "/Library/Input Methods/TaigiKeyboard.app"
end
