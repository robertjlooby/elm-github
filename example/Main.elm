module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import GitHub.OAuth
import GitHub.Repos
import GitHub.Users


main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }



-- MODEL


type alias Model =
    { oauthClientId : String
    , oauthRedirectUri : String
    , githubAccessToken : Maybe String
    , currentUser : Maybe GitHub.Users.User
    , userName : String
    , userData : Maybe GitHub.Users.User
    , repoName : String
    , repoData : Maybe GitHub.Repos.Repo
    }


init : { githubClientId : String, githubAccessToken : Maybe String } -> ( Model, Cmd Msg )
init { githubClientId, githubAccessToken } =
    let
        cmd =
            case githubAccessToken of
                Just token ->
                    GitHub.Users.getCurrentUser token
                        |> Http.send LoadCurrentUser

                Nothing ->
                    Cmd.none
    in
        ( Model
            githubClientId
            "http://localhost:3000/github_oauth_redirect"
            githubAccessToken
            Nothing
            ""
            Nothing
            ""
            Nothing
        , cmd
        )



-- UPDATE


type Msg
    = SetUser String
    | LoadUser (Result Http.Error GitHub.Users.User)
    | SetRepo String
    | LoadRepo (Result Http.Error GitHub.Repos.Repo)
    | LoadCurrentUser (Result Http.Error GitHub.Users.User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetUser newUserName ->
            let
                cmd =
                    GitHub.Users.get newUserName
                        |> Http.send LoadUser
            in
                ( { model | userName = newUserName }, cmd )

        LoadUser (Err _) ->
            ( { model | userData = Nothing }, Cmd.none )

        LoadUser (Ok user) ->
            ( { model | userData = Just user }, Cmd.none )

        SetRepo newRepoName ->
            let
                cmd =
                    GitHub.Repos.get model.userName newRepoName
                        |> Http.send LoadRepo
            in
                ( { model | repoName = newRepoName }, cmd )

        LoadRepo (Err _) ->
            ( { model | repoData = Nothing }, Cmd.none )

        LoadRepo (Ok repo) ->
            ( { model | repoData = Just repo }, Cmd.none )

        LoadCurrentUser (Err _) ->
            ( { model | currentUser = Nothing }, Cmd.none )

        LoadCurrentUser (Ok user) ->
            ( { model | currentUser = Just user }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        userInfo =
            case model.currentUser of
                Just user ->
                    div []
                        [ img [ src <| GitHub.Users.getAvatarUrl user ] []
                        , text <| toString user
                        ]

                Nothing ->
                    a [ href <| GitHub.OAuth.url model.oauthClientId model.oauthRedirectUri ] [ text "log in" ]
    in
        div []
            [ userInfo
            , h2 [] [ text model.userName ]
            , div []
                [ label [] [ text "username: " ]
                , input [ value model.userName, onInput SetUser ] []
                ]
            , div [] [ text <| toString model.userData ]
            , div []
                [ label [] [ text "repo: " ]
                , input [ value model.repoName, onInput SetRepo ] []
                ]
            , div [] [ text <| toString model.repoData ]
            ]
