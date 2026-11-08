# Step 2: Visualizing the Metafly with RViz

### Download Instructions for Step 2
Step 2 requires the use of ROS. On ThinLinc (or your personal Linux machine, if you opt to use that), run
```
cd ~/ece569-spring2026
git clone <paste your git@github.com:xxxxx/Lab3.git for your personal Lab3 repo here>
```
just like you did in Lab 2. If you need a refresher, take a look. You can then verify that you can push by adding your name and email to this `README.md` file and pushing your changes to GitHub.

In the interest of time, we have given you lots and lots of starter code which you just need to copy/paste into the correct locations. But first, you will need to create a workspace for Lab 3.

## ROS Workspace
Similar to lab 2, you will create a workspace called `ws3` inside of your `~/ece569-spring2026/Lab3` folder.
```bash
cd ~/ece569-spring2026/Lab3
mkdir -p ws3/src
```

Then be sure to edit your `~/.bashrc` file so that when you run `cb` the correct workspace is built and sourced.

## Metafly Description Package
We will make a basic model of the Metafly. You will need to 
1. Create a ros package called `metafly_description` (see Lab 2, Step 3 for a reminder on how to create a ros package). Make sure you create the package in the `ws3/src` folder!!
2. Move the `.xacro` files and the `.launch.py` file to the correct location in your `metafly_description` package.
3. Build the package with `cb`.
4. Verify that you can visualize the metafly and move its wings up and down using the joint-state-publisher-gui. (Be sure to set the fixed frame to `base_link` instead of `world` or similar.)
```bash
ros2 launch metafly_description view_metafly.launch.py
```

(If you were one of the students from Lab 2 that could not use the joint-state-publisher-gui because you were using a VM and had issues with the QT package running virtually, you can modify the `.launch.py` file to use the joint-state-publisher instead. For example:
```python
Node(
  package='joint_state_publisher',
  executable='joint_state_publisher',
  name='joint_state_publisher',
  output='screen',
  parameters=[{'zeros': {'joint1': 0.1, 'joint2': 0.2}}]
),
```

## The tf2 Package
One of the most useful tools in ros2 is the `tf2` package, which is used for communicating the relationship between frames. [The official ROS tutorial on tf2 frames can be found here](https://docs.ros.org/en/humble/Tutorials/Intermediate/Tf2/Introduction-To-Tf2.html), which you may want to refer to after you have completed step 2, in order to learn some of the more advanced features. A fantastic resource for understanding `tf2` is provided by the independent creator [Articulated Robotics](https://articulatedrobotics.xyz/tutorials/ready-for-ros/tf/) (if you are serious about learning ROS for outside of ECE 569, check out his "Articulated Robotics" YouTube channel! When I was first learning ROS, his videos were extremely helpful.)

Let's get started with a simple example. Launch the `view_metafly.launch.py` script. Then, in another terminal, run
```
ros2 run tf2_tools view_frames
```
This will generate a .pdf file which visualizes the relationships between all of the frames. The file will be named something like `frames_YYYY-MM-DD-hh.mm.ss.pdf`. You can run the `ls | grep *.pdf` command to view all the .pdf files in your local directory. Open the .pdf file in some application, for example, firefox. (This only works if you have firefox installed on your machine, but you can use any software that supports .pdf)
```
firefox frames_2024-09-14_11.39.21.pdf
```
Of course, your filename will be different. You can type `firefox frames_` and then press the `Tab` button a few times until it autocompletes some text, and then you can type the pdf extension before hitting enter)

You should see that `base_link` has two children: `wing1` and `wing2`.

The `view_frames` executable created this image by listening on the `/tf` topic. This is a special topic that is reserved for publishing `tf2_msgs/msg/TFMessage` messages.

### What are tf2_msgs/msg/TFMessage messages?

_Question: how do we know that there are `tf2_msgs/msg/TFMessage` messages on the `/tf` topic?_ 
Answer: We can run `ros2 topic list -t` to list all of the active topic types:
```
/clicked_point [geometry_msgs/msg/PointStamped]
/goal_pose [geometry_msgs/msg/PoseStamped]
/initialpose [geometry_msgs/msg/PoseWithCovarianceStamped]
/joint_states [sensor_msgs/msg/JointState]
/parameter_events [rcl_interfaces/msg/ParameterEvent]
/robot_description [std_msgs/msg/String]
/rosout [rcl_interfaces/msg/Log]
/tf [tf2_msgs/msg/TFMessage]
/tf_static [tf2_msgs/msg/TFMessage]
```
You can also just run `ros2 topic info /tf` to get information about only the `/tf` topic.

_Question: what is the general structure of a `tf2_msgs/msg/TFMessage` message?_
Answer: We can run `ros2 interface show tf2_msgs/msg/TFMessage`:
```
geometry_msgs/TransformStamped[] transforms
        #
        #
        std_msgs/Header header
                builtin_interfaces/Time stamp
                        int32 sec
                        uint32 nanosec
                string frame_id
        string child_frame_id
        Transform transform
                Vector3 translation
                        float64 x
                        float64 y
                        float64 z
                Quaternion rotation
                        float64 x 0
                        float64 y 0
                        float64 z 0
                        float64 w 1
```
We see that a `tf2_msgs/msg/TFMessage` message is just a list of transforms. Each transform contains a time stamp, information about the (parent) frame, child frame, as well as the position/rotation offset. Rotations are expressed as a unit quaternion.
_Aside: Rotations are expressed as unit quaternions because unit quaternions (unlike roll pitch yaw) provide a global coordinate representation of SO(3), but use only four numbers instead of the nine that rotation matrices require. In addition, unit quaternions are nice to work with on computers because they are 4-vectors of length 1: if we do some calculations on our computer and the new quaternion has length 0.99997 due to floating point arithmetic errors, we can just re-normalize our quaternions to be unit length. In simulations, this is especially helpful, because significant numerical drift can occur after thousands of calculations! Their biggest weakness is that every rotation matrix corresponds to exactly two unique quaternions of opposite sign, and so sometimes in simulation the quaternion will "flip signs" so you have to add checks into the simulation so that this does not happen._

_Question: OK, but what does an actual `tf2_msgs/msg/TFMessage` message look like?_
Answer: let's observe! Run `ros2 topic echo /tf` to get a continuous stream of messages (or add the `--once` flag to just get one message). The rotation values should change as you flap the wings! You should confirm that this message structure makes sense, given what you've already learned. Additionally, think about why the translation offsets are both set to zero. Can you visualize the frames in RViz? (You don't need to write down these answers, but you should play around with RViz to make sure you are following so far.)
```yaml
transforms:
- header:
    stamp:
      sec: 1726331108
      nanosec: 78266444
    frame_id: base_link
  child_frame_id: wing1
  transform:
    translation:
      x: 0.0
      y: 0.0
      z: 0.0
    rotation:
      x: 0.0
      y: 0.2313064479574571
      z: 0.0
      w: 0.9728809419108303
- header:
    stamp:
      sec: 1726331108
      nanosec: 78266444
    frame_id: base_link
  child_frame_id: wing2
  transform:
    translation:
      x: 0.0
      y: 0.0
      z: 0.0
    rotation:
      x: 0.0
      y: 0.36095732063089203
      z: 0.0
      w: 0.9325823356052629
---
```

### What is publishing these frames?
With your `view_metafly.launch.py` script still running, run `rqt_graph`. Make sure you have selected `Nodes/Topics (all)` and pressed the refresh button so you can see the nodes and topics.

The circles represent nodes, while the boxes repersent topics. We see that the `/robot_state_publisher` takes in the joint information and, since we gave it our URDF information (take a look at your `view_metafly.launch.py` file), it does all of the forward kinematics required to get the transforms between each frame before publishing to the `/tf` topic. (In Lab 3, you will get the chance to implement forward kinematics yourself :robot:). We see that the  `/robot_state_publisher` also publishes the URDF information to `/robot_description`, which our `/joint_state_publisher` node subscribes to. (The `/joint_state_publisher` reads this information in order to determine what joints exist). RViz is running the `/transform_listener` to display these frames in RViz.

Let's take another look at our `view_metafly.launch.py` file. At this point in the class, you should be able to see how these nodes are all working together. Note that the `joint_state_publisher_gui` package is sort of a wrapper for the `/joint_state_publisher`, which simply runs the `/joint_state_publisher` with a nice graphical user interface (gui).
```python
    joint_state_publisher_node = Node(
        package="joint_state_publisher_gui",
        executable="joint_state_publisher_gui",
    )
    robot_state_publisher_node = Node(
        package="robot_state_publisher",
        executable="robot_state_publisher",
        output="both",
        parameters=[robot_description],
    )
    rviz_node = Node(
        package="rviz2",
        executable="rviz2",
        name="rviz2",
        output="log",
        arguments=["-d", rviz_config_file],
    )
```

## Making Metafly "Fly"
Now that you have a basic understanding of the `/tf` message, let's use these tools to visualize the trajectory of the Metafly from the mocap data. The secret is to introduce a new frame, called `world`, which will be the parent of `base_link`. This new frame will be our fixed frame in RViz. Then, we can publish our own messages to `/tf` via the `metafly_tf_pub` node in order to move Metafly around.

## Metafly TF Publisher
Perform the following steps in order to create the `metafly_tf_pub`.
1. Create a ros package named `metafly_tf_pub`. Be sure to create the package in the `ws2/src` folder!
2. Install the [transforms3d](https://matthew-brett.github.io/transforms3d/reference/transforms3d.euler.html) python module using `pip install transforms3d` from your terminal.
3. Move the [metafly_tf_pub.py](metafly_tf_pub/metafly_tf_pub.py) file to the `ws2/src/metafly_tf_pub/metafly_tf_pub` folder, and the [mocap_data.csv](metafly_tf_pub/mocap_data.csv) into the `resource` folder. Also, update your `setup.py` file with the one provided.

Now, you can build the package and source your workspace. Verify that everything works by running
```bash
ros2 run metafly_tf_pub metafly_tf_pub
```
in one terminal, and then in another terminal please run
```bash
ros2 topic echo --once /tf
```
and then verify that you are receiving something like this:
```yaml
transforms:
- header:
    stamp:
      sec: 1726251497
      nanosec: 687890432
    frame_id: world
  child_frame_id: base_link
  transform:
    translation:
      x: -0.304972601
      y: -2.728537576
      z: 3.606290484
    rotation:
      x: 0.05287538205647302
      y: 0.3428150051202803
      z: 0.42970694030558765
      w: 0.8336869986331646
---
```
Alternatively, you could have run
```bash
ros2 run tf2_ros tf2_monitor world base_link
```
to confirm that frames are being published between world and base_link.


Let's take a quick look at your `metafly_tf_pub.py` file. It should remind you of your talker node from Lab 1 Step 3, with its use of timers and callback functions publishing to a topic. In particular, we should pay attention to creating and sending a message on `/tf`:
```python
    def broadcast_tf(self):
        tf = TransformStamped()

        # Header
        tf.header.stamp = self.get_clock().now().to_msg()
        tf.header.frame_id = 'world'  # parent frame
        tf.child_frame_id = 'base_link'  # child frame

        # Position
        tf.transform.translation.x = self.x[self.i]
        tf.transform.translation.y = self.y[self.i]
        tf.transform.translation.z = self.z[self.i]

        # Orientation (convert Euler to Quaternion with transforms3d.euler module)
        # x-axis is pitch
        # y-axis is roll
        # z-axis is yaw (z up)
        q = euler2quat(self.pitch[self.i], self.roll[self.i], self.yaw[self.i])
        tf.transform.rotation.w = q[0]
        tf.transform.rotation.x = q[1]
        tf.transform.rotation.y = q[2]
        tf.transform.rotation.z = q[3]

        # Broadcast the transform
        self.tf_broadcaster.sendTransform(tf)
        
        # update the index
        self.i += 1
        self.i %= self.data_length
```
This code should be pretty self explanatory. We simply fill out each field for the `TransformStamped` message using our mocap data. We reset the index when we run out of data, to keep the simulation looping over and over. One final comment is that we actually set the timer callback to run at 10 Hz, while the mocap data is saved at 100 Hz. This effectively makes the simulation run at 10% speed. We chose to do this simply because there is only 800 ms of mocap data we have available. (This mocap data was collected in a very large airplane hanger last year, and the metafly is very small, so it was difficult to get complete data for long stretches of time.)

## Metafly Launch File
The [metafly.launch.py](metafly.launch.py) file has been created for you to just run. From the Step2 folder, just run
```bash
ros2 launch metafly.launch.py
```
and RViz should open, and the Metafly should start moving around! The only strange line of code is the following:
```python
    joint_state_publisher_node = Node(
        package="joint_state_publisher",
        executable="joint_state_publisher",
        name="joint_state_publisher",
        output="both",
        parameters=[robot_description, {'zeros.joint1': 0.707, 'zeros.joint2': -0.707}],
    )
```
In this code, we are using a new feature of `joint_state_publisher` to send static joint data to `/joint_states` upon start up. Then, the `robot_state_publisher` node (which we launch next) will publish the `tf`s between the `base_link` and `wing1`/`wing2` to the `/tf` topic. (If you want, you can replace this code with `joint_state_publisher_gui` and then flap the wings manually using the sliders. If you are running this one your own Linux machine, you can get rid of the joint state publisher altogether, and use the [joy package](https://index.ros.org/p/joy/#humble) to connect an Xbox controller, and then write a custom ROS node to convert these messages from the `/joy` topic to the `/joint_states` topic. This is what I do for my bicopter research!)

_Aside: you may be wondering why, after all of this, we decided to fix the Metafly joints in place. The mocap data we collected doesn't provide any information about joint angles of the wings. Moreover, if we make the Metafly flap at 15 Hz, you really can't tell that it is flapping since the Rviz window refreshes at 30 Hz. Because of this, one could argue that there is little value in adding these wing joints in the URDF file if we aren't going to move them anyways. This is a valid point, but I already created the joints in the metafly description package, and I personally liked the ability to flap the wings with the joint state publisher gui, so I left it how it is. In the future, we could add a potentiometer to the wing joints, so we could actaully have the joint angle data alongside the mocap data._

**Take a screenshot of the Metafly flying through space in RViz. Ensure that a trail is shown for the base_link (in RViz go to RobotModel -> Links -> base_link -> Show Trail)**

## A few more comments
I did not talk about the `/tf_static` topic at all. This topic is used for describing transformations between frames which don't change. For example, any fixed joints will appear on the `/tf_static` topic. This topic only gets published to once, and its value doesn't change. Thus, ROS saves bandwidth by only publishing the frames which have the ability to move on `/tf` at 10 Hz. For example, your `ur3e_on_table` from Lab 2 has a table which doesn't move relative to world, and who's legs don't move relative to the table_top. You can go back to Step 1 if you'd like and take a look at the output of `/tf_static`, to get a complete picture.

## More Features of tf2

The `tf2_echo` executable is useful in practice because it automatically gives us the `T_sb` matrix. You can run it with the follwing command:
```bash
ros2 run tf2_ros tf2_echo <parent_frame> <child_frame> <Hz>
```

Here is the output of `ros2 run tf2_ros tf2_echo world base_link 10`:
```
At time 1726337498.390844480
- Translation: [-0.119, -2.855, 3.616]
- Rotation: in Quaternion [0.020, 0.324, 0.398, 0.858]
- Rotation: in RPY (radian) [0.355, 0.571, 0.974]
- Rotation: in RPY (degree) [20.325, 32.691, 55.815]
- Matrix:
  0.473 -0.670  0.572 -0.119
  0.696  0.682  0.224 -2.855
 -0.540  0.292  0.789  3.616
  0.000  0.000  0.000  1.000
```

Some more advanced features of `tf2` such as [Time Travel](https://docs.ros.org/en/humble/Tutorials/Intermediate/Tf2/Time-Travel-With-Tf2-Cpp.html) are available for C++ users, but we won't be covering this in the course. If you are curious, give it a read!


### Troubleshooting

10/29/25: using `colcon build` without the `--symlink-install` option may result in a `.csv` file not found error when trying to run the `metafly_tf_pub`. If you are getting a .csv file not found error then you should remove the `build/ log/ install/` folders and then run with the `--symlink-install` option. Also, here is my `setup.py` if that helps.

```python
from setuptools import find_packages, setup

package_name = 'metafly_tf_pub'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        ('share/' + package_name, ['resource/mocap_data.csv'])
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Logan Dihel',
    maintainer_email='ldihel@purdue.edu',
    description='publisher for tf frames',
    license='Apache-2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'metafly_tf_pub = metafly_tf_pub.metafly_tf_pub:main',
        ],
    },
)
```