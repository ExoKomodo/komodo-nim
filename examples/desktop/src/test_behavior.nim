import strformat

import komodo/ecs/components/behavior_macros
import komodo/logging

behavior TestBehavior:
    fields:
        discard

    create:
        discard
    
    init:
        discard

    update:
        logInfo(fmt"Hello from {self.id}")
    
    final:
        discard