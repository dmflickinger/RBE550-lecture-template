from PIL import Image, ImageDraw, ImageFont
import random
import math

# EGA color palette (16 colors)
ega_colors = [
    (0, 0, 0),        # Black
    (0, 0, 170),      # Blue
    (0, 170, 0),      # Green
    (0, 170, 170),    # Cyan
    (170, 0, 0),      # Red
    (170, 0, 170),    # Magenta
    (170, 85, 0),     # Brown
    (170, 170, 170),  # Light Gray
    (85, 85, 85),     # Dark Gray
    (85, 85, 255),    # Light Blue
    (85, 255, 85),    # Light Green
    (85, 255, 255),   # Light Cyan
    (255, 85, 85),    # Light Red
    (255, 85, 255),   # Light Magenta
    (255, 255, 85),   # Yellow
    (255, 255, 255)   # White
]

# Image Dimensions
width, height = 640, 350


# Grid dimensions
grid_width = 68
grid_height = 12
grid_sq = 8

# Grid origin in image
grid_x = 40
grid_y = 40

# Tetromino shapes (using a simplified 4x4 grid for each shape)
SHAPES = [
    [[1, 1, 1, 1]],        # I
    [[1, 1], [1, 1]],      # O
    [[0, 1, 0], [1, 1, 1]],# T
    [[1, 1, 0], [0, 1, 1]],# S
    [[0, 1, 1], [1, 1, 0]],# Z
    [[1, 0, 0], [1, 1, 1]],# L
    [[0, 0, 1], [1, 1, 1]] # J
]


def collision_check(grid, shape, x, y):
    """ Check if a tetromino can be placed at position (x, y) on the grid
        returns true if valid, false if in collision
    """

    for row in range(len(shape)):
        for col in range(len(shape[row])):
            if shape[row][col]:
                _x = x + col
                _y = y + row
                if _x < 0 or _x >= grid_width or _y < 0 or _y >= grid_height:
                    # out of bounds
                    return False
                if grid[_y][_x] != 0:
                    return False
    return True


def place_tetromino(grid, shape, x, y, color):
    """ Place a tetromino on the grid at position (x, y) with given color
    """
    
    for row in range(len(shape)):
        for col in range(len(shape[row])):
            if shape[row][col]:
                _y = y + row
                _x = x + col
                if (_x >= 0 and _x < grid_width) and (_y >= 0 and _y < grid_height):
                    grid[_y][_x] = color

def erase_tetromino(grid, shape, x, y):
    place_tetromino(grid, shape, x, y, 0)

def rot_cw(shape):
    """ rotate shape clockwise
    """
    
    # transpose
    shape_t = list(zip(*shape))

    # reverse each row in the transposed matrix
    return [list(reversed(row)) for row in shape_t]



def calc_total_height(grid):
    """ calculate the total height of all columns
    """
    total_height = 0
    for _r in range(grid_height):
        for _c in range(grid_width):
            if grid[_r][_c] > 0:
                total_height += grid_width - _c
                break
    return total_height / (grid_width * grid_height)

def calc_holes(grid):
    """ calculate the number of cells in the grid that are blocked
        (i.e. empty cell with an occupied cell to the left)
    """

    num_blocked = 0

    for _r in range(grid_height):
        for _c in range(1, grid_width):
            if grid[_r][_c] == 0 and grid[_r][_c - 1] > 0:
                num_blocked += 1
    
    return num_blocked / (grid_width * grid_height)



def calc_complete(grid):
    """ calculate the number of completed columns
    """

    num_complete = 0
    for _c in range(grid_width):
        if all(grid[_r][_c] > 0 for _r in range(grid_height)):
            num_complete += 1

    return 1 - (num_complete / grid_width)


def calc_bumpiness(grid):
    """ calculate the discontinuity at the interface
    """

    heights = []
    for _r in range(grid_height):
        for _c in range(grid_width):
            if grid[_r][_c] > 0:
                heights.append(_c)

    h_sum = 0
    for idx in range(len(heights) - 1):
        h_sum += abs(heights[idx+1] - heights[idx])

    return h_sum / (grid_width * grid_height)


def calc_max_height(grid):
    min_col = grid_width
    for _r in range(grid_height):
        for _c in range(grid_width):
            if (grid[_r][_c] > 0) and (_c < min_col):
                min_col = _c

    return (grid_width - min_col) / grid_width


def find_best_fit(grid, shape):
    """ calculate the goal (y position, and rotation) of the current shape for the current grid
    """

    shadow_grid = grid
    cfg_scores = []

    # score based on weights of
    # * total height
    # * number of holes
    # * number of complete lines
    # * bumpiness

    # simulate for each orientation
    for _rot in range(3):

        # simulate a drop from each row
        for _r in range(grid_height - 1):
            for _c in range(grid_width):
                if not collision_check(grid, shape, _c, _r):
                    place_tetromino(shadow_grid, shape, _c - 1, _r, 1)

                    cfg_score = 0.2 * calc_total_height(shadow_grid)
                    cfg_score += 0.2 * calc_holes(shadow_grid)
                    cfg_score += 0.2 * calc_complete(shadow_grid)
                    cfg_score += 0.2 * calc_bumpiness(shadow_grid)
                    cfg_score += 0.2 * calc_max_height(shadow_grid)
                    cfg_scores.append(cfg_score)

                    erase_tetromino(shadow_grid, shape, _c - 1, _r)
                    break

        shape = rot_cw(shape)

    best_row = cfg_scores.index(min(cfg_scores))

    best_orientation = math.floor(best_row / (grid_height - 1))
    best_row = best_row % (grid_height - 1)

    return best_row, best_orientation
        

def left_col_occupied(grid):
    """ is a cell in the leftmost column occupied?
    """

    for _r in range(grid_height):
        if grid[_r][0] > 0:
            return True
    return False



def create_empty_grid(width, height):
    """ Create an empty grid of given width and height
    """
    return [[0 for _ in range(width)] for _ in range(height)]


def render_grid(grid, dh):
    """ render the grid
    """

    for row in range(len(grid)):
        for col in range(len(grid[row])):
            if 0 != grid[row][col]:
                dh.rectangle([
                    grid_x + col * grid_sq,
                    grid_y + row * grid_sq,
                    grid_x + (col + 1) * grid_sq,
                    grid_y + (row + 1) * grid_sq
                ], fill=ega_colors[grid[row][col]])

def render_debug(target_row, turns_remaining, dh):
    """ render debugging marks
    """

    # target row
    dh.rectangle([
        grid_x + grid_width * grid_sq,
        grid_y + target_row * grid_sq,
        grid_x + (grid_width + 1) * grid_sq,
        grid_y + (target_row + 1) * grid_sq
        ], fill=ega_colors[9])

    # number of turns remaining
    for incr in range(turns_remaining):
        dh.rectangle([
            incr * 2 * grid_sq,
            0,
            incr * 2 * grid_sq + grid_sq,
            grid_sq
            ], fill=ega_colors[3])
        
    # draw grid limits
    dh.rectangle([
        grid_x,
        grid_y,
        grid_x + grid_width * grid_sq,
        grid_y + grid_height * grid_sq
        ], fill=ega_colors[15])
        

def render_background(dh):
    """ render the background
    """

    # make white background
    dh.rectangle([0, 0, width, height], fill=ega_colors[7])

    # make red stripe at top
    dh.rectangle([0, 0, width, grid_sq], fill=ega_colors[4])

    # TODO: draw low-res WPI logo

    # TODO: draw text at bottom, saying "LOADING LECTURE n ..."
    font = ImageFont.truetype("/usr/share/fonts/googlefonts/Orbitron-800.ttf", size=30)

    lecture_num = 0 # FIXME: get lecture number from command line argument
    text_content = f"LOADING LECTURE #{lecture_num} ..."
    text_color = (0, 0, 0)  # White color (RGB)
    text_position = (5, 300)     # X, Y coordinates

    dh.text(text_position, text_content, fill=text_color, font=font)


# Create a list to hold all frames
frames = []

# Create an empty grid
main_grid = create_empty_grid(grid_width, grid_height)

# Current tetromino position and shape
current_shape = random.choice(SHAPES)
x, y = 0, 4  # Start off-screen to the left

y_goal = 4

frame_count = 0
move_count = 0
rot_count = 0

while frame_count < 100000:

    frame_count += 1
    
    erase_tetromino(main_grid, current_shape, x, y)

    if left_col_occupied(main_grid):
        break
    

    # rotate tetromino  (if it doesn't collide)    
    if (0 == move_count % 3) and (rot_count > 0):
        tmp_shape = rot_cw(current_shape)
        if collision_check(main_grid, tmp_shape, x, y):
            current_shape = tmp_shape
            rot_count -= 1



    # move tetromino
    move_count += 1
    x += 1
    if (y > y_goal):
        if collision_check(main_grid, current_shape, x, y -1):
            y -= 1
    if (y < y_goal):
        if collision_check(main_grid, current_shape, x, y + 1):
            y += 1

    if collision_check(main_grid, current_shape, x, y):
        place_tetromino(main_grid, current_shape, x, y, 4)
    else:
        place_tetromino(main_grid, current_shape, x-1, y, 4)

        # create new tetromino
        x, y = 0, 4
        current_shape = random.choice(SHAPES)
        place_tetromino(main_grid, current_shape, x, y, 4)

        y_goal, rot_count = find_best_fit(main_grid, current_shape)

        if move_count <= 1:
            break
        move_count = 0



    # Draw the current frame with all tetrominos in place
    img = Image.new('P', (width, height), color=0)  # Black background
    draw = ImageDraw.Draw(img)

    render_background(draw)
    # render_debug(y_goal, rot_count, draw)
    render_grid(main_grid, draw)

 

    # Convert to RGB mode for saving as GIF
    rgb_img = img.convert('RGB')

    # Append frame to the list
    frames.append(rgb_img)



fps = 30
clip_duration = 5 # seconds

frames_required = clip_duration * fps
frame_step = math.floor(len(frames) / frames_required)

selected_frames = frames[::frame_step]

print(f"{len(frames)} frames generated, writing {frames_required} frames (step {frame_step})")



# Save all frames as an animated GIF
frames[0].save(
    'tetromino_animation.gif',
    save_all=True,
    append_images=selected_frames[1:],
    duration=1000/fps,  # Duration between frames in ms
    loop=0        # Loop indefinitely
)

