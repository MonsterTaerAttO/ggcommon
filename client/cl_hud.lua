RegisterNetEvent("shop:prompt")
AddEventHandler(
  "shop:prompt",
  function(result)
    if result ~= "" then
      SendNuiMessage(
        json.encode(
          {
            type = "ggtoaster",
            toasterMessage = result,
            toasterTop = true,
            toasterPosition = "center"
          }
        )
      )
    end
  end
)
