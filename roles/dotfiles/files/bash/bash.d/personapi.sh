
person-api-email() {
  local CLIENT_ID=$(gpg --decrypt --batch --quiet ~/.passwd/personapi.json.asc | jq .client_id -r)
  local CLIENT_SECRET=$(gpg --decrypt --batch --quiet ~/.passwd/personapi.json.asc | jq .client_secret -r)

  BEARER=$(curl --silent --request POST --url https://auth.mozilla.auth0.com/oauth/token --header "Content-Type: application/json" --data "{\"client_id\":\"${CLIENT_ID}\",\"client_secret\":\"${CLIENT_SECRET}\",\"audience\":\"api.sso.mozilla.com\",\"grant_type\":\"client_credentials\"}"| jq -r '.access_token')
  USERID=$(echo $1 | python3 -c "import urllib.parse; print(urllib.parse.quote(input()))")
  curl --silent -H "Authorization: Bearer $BEARER" https://person.api.sso.mozilla.com/v2/user/primary_email/$USERID | jq 'walk(if type == "object" then with_entries(select(.key | test("signature|metadata") | not)) else . end) | walk(if type == "object" and has("values") then .values else . end) | walk(if type == "object" and has("value") then .value else . end)'
}

person-api-userid() {
  local CLIENT_ID=$(gpg --decrypt --batch --quiet ~/.passwd/personapi.json.asc | jq .client_id -r)
  local CLIENT_SECRET=$(gpg --decrypt --batch --quiet ~/.passwd/personapi.json.asc | jq .client_secret -r)

  BEARER=$(curl --silent --request POST --url https://auth.mozilla.auth0.com/oauth/token --header "Content-Type: application/json" --data "{\"client_id\":\"${CLIENT_ID}\",\"client_secret\":\"${CLIENT_SECRET}\",\"audience\":\"api.sso.mozilla.com\",\"grant_type\":\"client_credentials\"}" | jq -r '.access_token')
  USERID=$(echo $1 | python3 -c "import urllib.parse; print(urllib.parse.quote(input()))")
  curl --silent -H "Authorization: Bearer $BEARER" "https://person.api.sso.mozilla.com/v2/user/user_id/$USERID" | jq 'walk(if type == "object" then with_entries(select(.key | test("signature|metadata") | not)) else . end) | walk(if type == "object" and has("values") then .values else . end) | walk(if type == "object" and has("value") then .value else . end)'
}
