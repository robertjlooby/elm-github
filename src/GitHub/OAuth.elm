module GitHub.OAuth exposing (url)


url : String -> String -> String
url clientId redirectUri =
    "https://github.com/login/oauth/authorize?client_id=" ++ clientId ++ "&redirect_uri=" ++ redirectUri
