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
    maintainer='your name',
    maintainer_email='youremail@purdue.edu',
    description='publisher for tf frames',
    license='Apache-2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'metafly_tf_pub = metafly_tf_pub.metafly_tf_pub:main',
        ],
    },
)
