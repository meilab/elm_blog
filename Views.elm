module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (href, src)
import Markdown
import Messages exposing (Msg(..))
import Models exposing (..)
import ViewHelpers exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Styles.SharedStyles exposing (..)
import Types exposing (..)
import RemoteData exposing (WebData, RemoteData(..))
import Routing exposing (Route(..))
import Views.Trainings exposing (renderTrainings)
import Views.Archives exposing (renderArchives)
import Views.Authors exposing (renderAuthors)


{ id, class, classList } =
    withNamespace "meilab"


view : Model -> Html Msg
view model =
    div [ class [ Layout ] ]
        [ navContainer model
        , header
        , body model
        , footer
        ]


header : Html Msg
header =
    Html.header [ class [ Header ] ]
        [ img
            [ src "/image/elm.png"
            , class [ ImgResponsive ]
            ]
            []
        , h1 [] [ text "Meilab" ]
        ]


body : Model -> Html Msg
body model =
    section [ class [ Body ] ]
        [ mainBody model, subContent ]


mainBody : Model -> Html Msg
mainBody model =
    div []
        [ h1 [] [ text model.currentContent.title ]
        , renderMeta model.currentContent
        , renderContent model
        ]


renderMeta : Content -> Html Msg
renderMeta content =
    case content.contentType of
        Types.Post ->
            div [ class [ ContentMeta ] ]
                [ p []
                    [ text
                        ("Published on " ++ ViewHelpers.formatDate content.publishedDate ++ " by " ++ content.author.name ++ ".")
                    ]
                ]

        _ ->
            div [] []


convertMarkdownToHtml : WebData String -> Html Msg
convertMarkdownToHtml markdown =
    case markdown of
        Success data ->
            Markdown.toHtml [ class [ MarkdownContent ] ] data

        Failure err ->
            Debug.log (toString (err))
                text
                "There was an error"

        _ ->
            text "Loading"


renderContent : Model -> Html Msg
renderContent model =
    case model.route of
        ArchiveRoute ->
            renderArchives model

        TrainingRoute ->
            renderTrainings model

        AuthorRoute ->
            renderAuthors

        _ ->
            renderMarkdown model.currentContent.markdown


renderMarkdown : WebData String -> Html Msg
renderMarkdown markdown =
    article [ class [ MarkdownWrapper ] ]
        [ convertMarkdownToHtml markdown ]


subContent : Html Msg
subContent =
    div [ class [ SubContent ] ]
        [ p [] [ text "" ] ]


footer : Html Msg
footer =
    Html.footer [ class [ Footer ] ]
        [ text "footer" ]
