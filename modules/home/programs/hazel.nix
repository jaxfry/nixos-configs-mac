{ ... }:
{
  # Hazel app is still installed manually, but these files restore your rules/preferences.
  # License is intentionally excluded.
  home.file."Library/Preferences/com.noodlesoft.Hazel.plist".source =
    ./hazel-backup/com.noodlesoft.Hazel.plist;
  home.file."Library/Preferences/86Z3GCJ4MF.com.noodlesoft.HazelHelper.plist".source =
    ./hazel-backup/86Z3GCJ4MF.com.noodlesoft.HazelHelper.plist;
  home.file."Library/Application Support/Hazel/16777230-36143.hazelrules".source =
    ./hazel-backup/16777230-36143.hazelrules;
  home.file."Library/Application Support/Hazel/16777230-36143.hazellocalrulesdb".source =
    ./hazel-backup/16777230-36143.hazellocalrulesdb;
}
