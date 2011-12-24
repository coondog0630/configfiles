// Possible mouse modes
typedef enum
{
    NO_MODE = 0,
    NORMAL_MODE,
    HILITE_MODE,
    BUTTON_MODE,
    ALL_MODE
} MouseMode;

// Control codes

#define PDA_RESPONSE "\033[?1;2c"
#define PDA_RESPONSE_LEN (sizeof(PDA_RESPONSE) - 1)
#define SDA_RESPONSE "\033[>0;95;c"
#define SDA_RESPONSE_LEN (sizeof(SDA_RESPONSE) - 1)

// Normal control codes
#define UP_ARROW "\033[A"
#define DOWN_ARROW "\033[B"
// Control codes for application keypad mode
#define UP_ARROW_APP "\033OA"
#define DOWN_ARROW_APP "\033OB"
#define ARROW_LEN (sizeof(UP_ARROW) - 1)

// Mode control codes

#define TOGGLE_ON 'h'
#define TOGGLE_OFF 'l'

// Excludes mode and toggle flag
#define TOGGLE_MOUSE "\033[?100"
#define TOGGLE_MOUSE_LEN (sizeof(TOGGLE_MOUSE) - 1)

// Excludes toggle flag
#define TOGGLE_CURSOR_KEYS "\033[?1"
#define TOGGLE_CURSOR_KEYS_LEN (sizeof(TOGGLE_CURSOR_KEYS) - 1)

// X11 mouse button values
typedef enum
{
    MOUSE_BUTTON1 = 0,
    MOUSE_BUTTON3 = 1,
    MOUSE_BUTTON2 = 2,
    MOUSE_RELEASE = 3,
    MOUSE_WHEEL_UP = 64,
    MOUSE_WHEEL_DOWN = 65
} MouseButton;

// X11 mouse reporting responses
#define MOUSE_RESPONSE "\033[M%c%c%c"
#define MOUSE_RESPONSE_LEN 6
