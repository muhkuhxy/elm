module Territory exposing (init, Territory)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.App exposing (beginnerProgram)
import Date exposing (Date)


main =
  beginnerProgram
    { model = init
    , view = view
    , update = update
    }

-- MODEL

type alias Model = Territory


init : Model
init =
  Territory [] "1101"


type alias Territory =
  { history: List Entry
  , id: String
  }


type alias Friend =
  { name: String
  }


type Entry
  = Issue IssueInfo
  | Return ReturnInfo
  | WorkedThrough WorkedThroughInfo


type alias IssueInfo =
  { to: Friend
  , on: String
  }


type alias ReturnInfo =
  { by: Friend
  , on: String
  , workedThrough: Bool
  }


type alias WorkedThroughInfo =
  { on: String
  }


update : Entry -> Model -> Model
update entry model =
  { model | history = entry :: model.history }


view model =
  div []
    [ text (Maybe.withDefault "" (Maybe.map toString (List.head model.history)))
    , button
      [ onClick (Issue (IssueInfo (Friend "Timon") "2016-07-13"))
      , disabled (not (isReturned model))
      ]
      [ text "Ausgeben" ]
    , button
      [ onClick (Return (ReturnInfo (Friend "Timon") "2016-07-13" True))
      , disabled (isReturned model)
      ]
      [ text "Zurück" ]
    ]

isReturned : Territory -> Bool
isReturned territory =
  Maybe.withDefault True
    ( Maybe.map
      (\entry ->
        case entry of
          Return _ -> True
          _ -> False
      ) (List.head territory.history)
    )
