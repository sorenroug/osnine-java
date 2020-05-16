import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioFormat.Encoding;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.UnsupportedAudioFileException;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.BufferedInputStream;

/**
 * If sample rate = 44100 then multiplier = 12.
 */
class ReadWav {

    private byte[] soundBuffer;
    private int frameSize;
    private AudioInputStream is;
    private boolean bigEndian;
    private Encoding encoding;

    private int readSample() throws Exception {
        int res = is.read(soundBuffer);
        if (res == -1) return res;

        if (frameSize == 1) {
            res = (soundBuffer[0] & 0xFF) << 8;

        } else if (frameSize == 2) {
            if (bigEndian)
                res = soundBuffer[1] + (soundBuffer[0] << 8);
            else
                res = soundBuffer[0] + (soundBuffer[1] << 8);
        }
        if (encoding == Encoding.PCM_SIGNED) {
            res += 32768; // Make it unsigned
        }
        return res;
    }

    private void tapestationReady(boolean newstate) {
    }

    public ReadWav() throws Exception {
        int multiplier = 0;

        //File wavFile = new File("la-cuisine-francaise_mo5.wav");
        //File wavFile = new File("16bit.wav");
        InputStream fileIS = new BufferedInputStream(
                            new FileInputStream("16bit.wav"));
        is = AudioSystem.getAudioInputStream(fileIS);
        AudioFormat format = is.getFormat();
        System.out.println(format.toString());
        float sampleRate = format.getSampleRate();
        frameSize = format.getFrameSize();
        bigEndian = format.isBigEndian();
        encoding = format.getEncoding();

        soundBuffer = new byte[frameSize];
        if (sampleRate == 44100f) multiplier = 12;
        if (sampleRate == 22050f) multiplier = 48;

        int b = readSample();
        int i = 0, exI = 0;
        int currB = b;

        while (b != -1) {
            i++;
            b = readSample();
            if (b != currB) {
                exI =  (i < 10000 * multiplier)?i * multiplier:i;
                System.out.format("B=%x, i=%d\n", currB, exI);
                tapestationReady(currB > 0x2000?true:false);
                i = 0;
                currB = b;
            }
        }
    }

    public static void main(String[] args) throws Exception {
        new ReadWav();
    }

}
