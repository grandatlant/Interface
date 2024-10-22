local folder, core = ...
local L = LibStub("AceLocale-3.0"):NewLocale(folder, "koKR")
if not L then return end
L["Add buffs above friendly plates"] = "우호적 대상의 이름표에 버프를 추가합니다."
L["Add buffs above hostile plates"] = "적대적 대상의 이름표에 버프를 추가합니다."
L["Add buffs above neutral plates"] = "중립적 대상의 이름표에 버프를 추가합니다."
L["Add buffs above NPCs"] = "NPC 이름표에 버프를 추가합니다."
L["Add buffs above players"] = "플레이어 이름표에 버프를 추가합니다."
L["Added: "] = "추가: "
L["Add spell"] = "주문 추가"
L["Add spell to list."] = "목록에 주문을 추가합니다."
L["All"] = "전체"
L["Always"] = "항상"
L["Always show spell, only show your spell, never show spell"] = "항산 주문을 표시합니다. 당신의 주문을 표시하거나 그렇지 않습니다."
L["Bar"] = "바"
L["Bar Anchor Point"] = "바 앵커 위치"
L["Bar Growth"] = "바 확장"
L["Bars"] = "바"
L["Bar X Offset"] = "바 X 간격"
L["Bar Y Offset"] = "바 Y 간격"
L["Blink spell if below x% timeleft, (only if it's below 60 seconds)"] = "만약 x% 남은 시간이면 주문을 깜박입니다. (60초 아래일 경우만)"
L["Blink Timeleft"] = "남은 시간 깜박임"
L["Bottom"] = "하단"
L["Bottom Left"] = "좌측 하단"
L["Bottom Right"] = "우측 하단"
L["Center"] = "중앙"
L["Cooldown Size"] = "재사용 대기시간 크기"
L["Cooldown Text Size"] = "재사용 대기시간 글자 크기"
L["Core"] = "코어"
L["Display a question mark above plates we don't know spells for. Target or mouseover those plates."] = "알 수 없는 주문은 이름표에 ? 부호로 표시합니다. 대상 선택이나 이름표에 마우스 오버시 표시합니다."
L["Down"] = "아래"
L["Enable"] = "사용"
L["Enables / Disables the addon"] = "애드온 사용 / 사용 안함"
L["Friendly"] = "우호적"
L["Hostile"] = "적대적"
L["Icon Size"] = "아이콘 크기"
L["Icons per bar"] = "바 당 아이콘"
L["Input a spell name. (case sensitive)"] = "주문 이름을 입력합니다. (대소문자 구분)"
L[ [=[Input a spell name. (case sensitive)
Or spellID]=] ] = "주문 이름을 입력합니다. (대소문자 구분) 또는 주문ID"
L["Larger self spells"] = "자신의 주문 크게"
L["Left"] = "좌측"
L["Left to right offset."] = "좌우 간격"
L["Make your spells 20% bigger then other's."] = "다른 플레이어의 주문보다 당신의 주문을 20% 크게 표시합니다."
L["Max bars"] = "최대 바"
L["Max number of bars to show."] = "표시할 바의 최대 숫자를 설정합니다."
L["Mine only"] = "나의 것만"
L["Mine Only"] = "나의 것만"
L["Neutral"] = "중립적"
L["Never"] = "Never"
L["None"] = "없음"
L["NPC"] = "NPC"
L["Number of icons to display per bar."] = "표시할 아이콘의 숫자를 설정합니다."
L["Other"] = "기타"
L["Plate Anchor Point"] = "이름표 앵커 위치"
L["Players"] = "플레이어"
L[ [=[Point of the buff frame that gets anchored to the nameplate.
default = Bottom]=] ] = [=[Point of the buff frame that gets anchored to the nameplate.
default = Bottom]=]
L[ [=[Point of the nameplate our buff frame gets anchored to.
default = Top]=] ] = [=[Point of the nameplate our buff frame gets anchored to.
default = Top]=]
L["Profiles"] = "프로필"
L["Reaction"] = "반응"
L["Remove Spell"] = "주문 삭제"
L["Remove spell from list"] = "목록에서 주문을 삭제합니다."
L["Right"] = "우측"
L["Row Growth"] = "위로 줄"
L["Save player GUID"] = "플레이어 GUID 저장"
L["Save player GUID's"] = "플레이어 GUID 저장합니다."
L["Show"] = "표시"
L["Show Aura"] = "오라 표시"
L["Show auras above nameplate. This sometimes causes duplicate buffs."] = "이름표에 오라를 표시합니다. 이것은 중복으로 버프를 표시할 수 있습니다."
L["Show bar background"] = "바 배경 표시"
L["Show Buffs"] = "버프들 표시"
L["Show buffs above nameplate."] = "이름표에 버프를 표시합니다."
L["Show by default"] = "기본값 표시"
L["Show cooldown"] = "재사용 대기시간 표시"
L["Show cooldown text under the spell icon."] = "주문 아이콘 아래 재사용 대기시간을 표시합니다."
L["Show Debuffs"] = "디버프들 표시"
L["Show debuffs above nameplate."] = "이름표에 디버프를 표시합니다."
L["Show spell icons on totems"] = "토템에 주문 아이콘을 표시합니다."
L["Show the area where spell icons will be. This is to help you configure the bars."] = "주문 아이콘 위치를 표시합니다. 이것은 당신이 바를 만들드록 도와줍니다."
L["Show Totems"] = "토템 표시"
L["Shrink Bar"] = "축소 바"
L["Shrink the bar horizontally when spells frames are hidden."] = "주문 프레임을 숨길때 수평으로 바를 축소합니다."
L["Size of the icons."] = "아이콘 크기를 설정합니다."
L["sizes: 9, 10, 12, 13, 14, 16, 20"] = "크기: 9, 10, 12, 13, 14, 16, 20"
L["Specific"] = "Specific"
L["Spell name"] = "주문 이름"
L["Spells"] = "주문"
L["spells to show by default"] = "기본 주문을 표시합니다."
L["Stack Size"] = "중첩 크기"
L["Test Mode"] = "테스트 모드"
L["Text size"] = "문자 크기"
L["Top"] = "상단"
L["Top Left"] = "좌측 상단"
L["Top Right"] = "우측 상단"
L["Type"] = "타입"
L["Unknown spell info"] = "알 수 없는 주문 정보"
L["Up"] = "위"
L["Up to down offset."] = "위 아래 간격"
L["Watch Combatlog"] = "Combatlog 보기"
L[ [=[Watch combatlog for people gaining/losing spells.
Disable this if you're having performance issues.]=] ] = "전투로그에서 주문 획득/잃음을 가져옵니다. 성능에 문제가 있다면 이것을 사용하지 마십시오."
L["Which way do the bars grow, up or down."] = "바를 위로 올리거나 아래로 내립니다."
L["Who"] = "누구"
