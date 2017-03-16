#= require flatpickr-calendar
#= require flatpickr-calendar/l10n/es
#= require flatpickr-calendar/l10n/cat

$ ->
  $.fn.enable_flatpickr = ->
    @flatpickr({
      enableTime: true,
      time_24hr: true,
      altInput: true,
      altFormat: "d \\de M \\de Y, H:i"
    })

  $(".js-datetime-picker").enable_flatpickr()

  $(document)
    .on "has_many_add:after", ".has_many_container", (e, fieldset, container) ->
      fieldset.find(".js-datetime-picker").enable_flatpickr()
