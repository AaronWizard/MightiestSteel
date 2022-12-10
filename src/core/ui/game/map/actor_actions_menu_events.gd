class_name ActorActionsMenuEvents
extends Resource

## Event bus used by actor action menus.
##
## Assumes only one actor action menu may be opened at a time. Saves user from
## having to connect to individual actor action menus.

signal attack_selected
signal skill_selected(skill_index: int)
signal wait_selected
