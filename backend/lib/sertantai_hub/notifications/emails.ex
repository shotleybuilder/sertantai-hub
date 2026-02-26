defmodule SertantaiHub.Notifications.Emails do
  @moduledoc """
  Builds Swoosh email structs for law change notifications.
  """

  import Swoosh.Email

  @from {"SertantAI Hub", "notifications@sertantai.com"}

  @doc """
  Builds an immediate notification email for a single law change event.
  """
  def immediate(to_email, event) do
    new()
    |> to(to_email)
    |> from(@from)
    |> subject("Law Change Alert: #{event.law_title}")
    |> text_body(immediate_text(event))
    |> html_body(immediate_html(event))
  end

  @doc """
  Builds a daily digest email summarising multiple law change events.
  """
  def digest(to_email, events) do
    count = length(events)

    new()
    |> to(to_email)
    |> from(@from)
    |> subject("Daily Law Change Digest — #{count} #{pluralize(count, "change")}")
    |> text_body(digest_text(events))
    |> html_body(digest_html(events))
  end

  defp immediate_text(event) do
    """
    Law Change Notification
    =======================

    #{String.capitalize(event.change_type)}: #{event.law_title}

    Legislation: #{event.law_name}
    Change type: #{event.change_type}
    #{if event.summary, do: "\n#{event.summary}\n", else: ""}
    View on legislation.gov.uk:
    https://www.legislation.gov.uk/#{event.law_name}

    ---
    You received this because of your subscription filter settings.
    Manage your subscriptions in SertantAI Hub settings.
    """
  end

  defp immediate_html(event) do
    """
    <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto;">
      <h2 style="color: #1e40af;">Law Change Notification</h2>
      <div style="background: #f0f9ff; border-left: 4px solid #3b82f6; padding: 16px; margin: 16px 0;">
        <h3 style="margin: 0 0 8px 0;">#{String.capitalize(event.change_type)}: #{escape_html(event.law_title)}</h3>
        <p style="margin: 4px 0; color: #6b7280;">Legislation: #{escape_html(event.law_name)}</p>
        <p style="margin: 4px 0; color: #6b7280;">Change type: #{event.change_type}</p>
        #{if event.summary, do: "<p style=\"margin: 8px 0;\">#{escape_html(event.summary)}</p>", else: ""}
      </div>
      <p><a href="https://www.legislation.gov.uk/#{event.law_name}" style="color: #2563eb;">View on legislation.gov.uk</a></p>
      <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 24px 0;" />
      <p style="font-size: 12px; color: #9ca3af;">You received this because of your subscription filter settings. Manage your subscriptions in SertantAI Hub settings.</p>
    </div>
    """
  end

  defp digest_text(events) do
    count = length(events)

    header = """
    Daily Law Change Digest
    =======================
    #{count} #{pluralize(count, "change")} matched your subscriptions today.

    """

    items =
      events
      |> Enum.map(fn event ->
        """
        • #{String.capitalize(event.change_type)}: #{event.law_title}
          #{event.law_name}
          https://www.legislation.gov.uk/#{event.law_name}
        """
      end)
      |> Enum.join("\n")

    footer = """

    ---
    Manage your subscriptions in SertantAI Hub settings.
    """

    header <> items <> footer
  end

  defp digest_html(events) do
    count = length(events)

    items =
      events
      |> Enum.map(fn event ->
        """
        <div style="background: #f0f9ff; border-left: 4px solid #3b82f6; padding: 12px 16px; margin: 8px 0;">
          <strong>#{String.capitalize(event.change_type)}: #{escape_html(event.law_title)}</strong>
          <br /><span style="color: #6b7280; font-size: 14px;">#{escape_html(event.law_name)}</span>
          <br /><a href="https://www.legislation.gov.uk/#{event.law_name}" style="color: #2563eb; font-size: 14px;">View on legislation.gov.uk</a>
        </div>
        """
      end)
      |> Enum.join("\n")

    """
    <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto;">
      <h2 style="color: #1e40af;">Daily Law Change Digest</h2>
      <p>#{count} #{pluralize(count, "change")} matched your subscriptions today.</p>
      #{items}
      <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 24px 0;" />
      <p style="font-size: 12px; color: #9ca3af;">Manage your subscriptions in SertantAI Hub settings.</p>
    </div>
    """
  end

  defp pluralize(1, word), do: word
  defp pluralize(_n, word), do: word <> "s"

  defp escape_html(nil), do: ""

  defp escape_html(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
  end
end
