

class audioGenerator:
    """! @brief audio generator
         @details Reads in configuration file defining the synthesized waveform and sound type, then reads a list of notes to play.  Finally, create the audio and encode to MP3 format and write the output file.
    """

    def __init__(cfg_fname, notes_fname, output_fname):
        """! @brief initialize audio generator
             @param[in] cfg_fname configuration file name (YAML)
             @param[in] notes_fname file containing notes to play
             @param[in] output_fname sound file output (MP3)
             @details Sets parameters, and file names
        """
        pass