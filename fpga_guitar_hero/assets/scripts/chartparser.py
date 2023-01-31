from tkinter.filedialog import askopenfilename
import os

print("Starting chart conversion")

difficulty = "[ExpertSingle]"
songinfo = "[Song]"
synctrack = "[SyncTrack]"
in_chart = 0
previous_beat = 0

resolution = 0

previous_line = ""

filename = askopenfilename()

timechanges = 0
timechangebeats = []
timechangems = []
tempos = []

def getTimeMs(beats):
    if beats == 0:
        return 0

    
    last_timechange = 0

    while int(beats) > timechangebeats[last_timechange] and last_timechange < timechanges:
        last_timechange += 1

    last_timechange -= 1

    note_ms = timechangems[last_timechange]
    
    note_offset = int(beats) - timechangebeats[last_timechange]

    time_offset = (60000000 * note_offset)/(tempos[last_timechange] * resolution)

    note_ms += time_offset;

    return note_ms

chartfile = open(filename, "r")
notesfile = open("notes.txt", "w")
beatsfile = open("beats.txt", "w")

beatsfile.write("int beats[] = {\n")
notesfile.write("int notes[] = {\n")

for line in chartfile:
    if songinfo in line:
        print("found song info")
        in_chart = 10
    if in_chart == 10:
        if "Resolution" in line:
            resolution = int(line.split()[2])
            print(f"resolution: {resolution}")
    if synctrack in line:
        print("found synctrac")
        in_chart = 20
    if in_chart == 20:
        if '{' in line:
            in_chart = 21
            continue
    if in_chart == 21:
        if '}' in line:
            in_chart = 0
            continue
        if line.split()[2] == "B":
            timechanges += 1
            tempos.append(int(line.split()[3]))
            timechangebeats.append(int(line.split()[0]))
            timechangems.append(getTimeMs(int(line.split()[0])))
    if difficulty in line:
        print(f"Found difficulty {difficulty}")
        in_chart = 1
    if in_chart == 1:
        if '{' in line:
            in_chart = 2
            continue
    if in_chart == 2:
        if '}' in line:
            in_chart = 3
            break
        if line.split()[2] == "N":
            if line.split()[0] == previous_beat:
                previous_line += " + BIT(" + line.split()[3] + ")"
            else:
                if previous_line != "":
                    notesfile.write(previous_line + ",\n")
                beatsfile.write("\t" + line.split()[0] + ", \n")
                previous_line = "\tBIT(" + line.split()[3] + ")"
            previous_beat = line.split()[0]
        
with open("tempo.txt", "w") as tempofile:
    tempofile.write("#include \"note.h\"\n\n")
    tempofile.write(f"int resolution = {resolution};\n\n")
    tempofile.write(f"int time_changes = {timechanges};\n\n")
    tempofile.write("int timechange_beat[] = {\n")
    for beat in timechangebeats:
        tempofile.write(f"\t{beat}, \n");
    tempofile.write("};\n\n")
    tempofile.write("int tempo[] = {\n")
    for tempo in tempos:
        tempofile.write(f"\t{tempo}, \n");
    tempofile.write("};\n\n")
    tempofile.write("int timechange_ms[] = {\n")
    for ms in timechangems:
        tempofile.write(f"\t{int(ms)}, \n");
    tempofile.write("};\n\n")

notesfile.write(previous_line + ",\n};\n")
beatsfile.write("};\n\n")
chartfile.close()
notesfile.close()
beatsfile.close()

filenames = ["tempo.txt", "notes.txt", "beats.txt"]
with open("chart.c", "w") as outfile:
    for file in filenames:
        with open(file) as infile:
            outfile.write(infile.read())

for file in filenames:
    os.remove(file)
