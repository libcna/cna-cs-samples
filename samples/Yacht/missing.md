# Yacht audit — CSSAMPLE-071 🛑

## Result

**Needs an owner decision: the client's WCF proxy is Silverlight's.** Measured 2026-10-01 against
CNA.NET `9360a28`; nothing beyond this record is checked in.

The upstream product is a Windows Phone client (`Yacht/Yacht/Yacht.csproj`, phone-only, no `Main`)
and a separate WCF game server. Everything the client needs from XNA and from the Windows Phone SDK
is in reach:

| Need | Where | State |
|---|---|---|
| Entry point | `<CnaPhoneGame>Yacht.YachtGame</CnaPhoneGame>` | as for every phone row |
| `System.ServiceModel` client types (`ClientBase<T>`, `ChannelBase<T>`, Begin/End operation delegates) | .NET's WCF client packages (`System.ServiceModel.Http`/`.Primitives`) | resolve |
| `DataModel.cs`, `ServiceConstants.cs` | linked from `YachtServices/`, as the upstream project links them | compile |
| `Microsoft.Phone.Notification.HttpNotificationChannel` | CNA.PhoneCompat | written and compiling, not committed (see below) |

What does not: the generated service reference (`Service References/YachtServiceReference/Reference.cs`)
passes endpoint-configuration *names* to `ClientBase<T>` — four constructors such as
`base(endpointConfigurationName)` — and the game calls the default one, which reads the endpoint
from `ServiceReferences.ClientConfig`. Silverlight's WCF client read that file; .NET's has no
configuration system at all, so those constructors do not exist and the default one cannot find an
endpoint. The four build errors are all in that generated file.

## The options

1. **A recorded source edit to the generated proxy**: drop the four configuration-name
   constructors. Offline play would then run (the proxy is only created on "Online Game"), and
   online would fail at `new YachtServiceClient()` with no endpoint. Small; leaves online dead.
2. **A Silverlight-compatible WCF client subset** in an opt-in assembly: `ClientBase<T>` with the
   configuration-name constructors reading `ServiceReferences.ClientConfig`, `BasicHttpBinding`,
   the event-based async pattern, SOAP 1.1 over HTTP; plus push notifications through a local
   endpoint standing in for the Microsoft Push Notification Service. Online play could then run
   against the C++ campaign's server port (`YachtServer_cna_samples`), which answers the original
   SOAP byte for byte. Large, and new code in the direction the owner asked to reduce (2026-09-28).

The C++ port reached online play by porting both products. Neither option is taken here without the
owner's word.
